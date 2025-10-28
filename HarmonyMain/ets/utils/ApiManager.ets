// API管理类 - 负责DeepSeek AI API调用
import dataPreferences from '@ohos.data.preferences'
import http from '@ohos.net.http'

const PREFERENCES_NAME = 'DrAppData'
const KEY_API = 'deepseek_api'

// 定义消息接口
interface ChatMessage {
  role: string
  content: string
}

// 定义请求体接口
interface ChatRequest {
  model: string
  messages: ChatMessage[]
  temperature: number
}

// 定义API响应接口
interface ChatChoice {
  message: ChatMessage
}

interface ChatResponse {
  choices: ChatChoice[]
}

class ApiManager {
  private preferences: dataPreferences.Preferences | null = null

  // 初始化
  async init(context: Context): Promise<void> {
    try {
      if (this.preferences) {
        console.info('ApiManager already initialized')
        return
      }
      this.preferences = await dataPreferences.getPreferences(context, PREFERENCES_NAME)
      console.info('ApiManager initialized successfully')
    } catch (err) {
      console.error('初始化API管理失败:', err)
    }
  }

  // 保存API Key
  async saveApiKey(apiKey: string): Promise<boolean> {
    try {
      if (!this.preferences) {
        console.error('ApiManager not initialized')
        return false
      }
      
      console.info('保存API Key，长度:', apiKey.length)
      await this.preferences.put(KEY_API, apiKey)
      await this.preferences.flush()
      console.info('API Key保存成功')
      return true
    } catch (err) {
      console.error('保存API Key失败:', err)
      return false
    }
  }

  // 获取API Key
  async getApiKey(): Promise<string> {
    try {
      const apiKey = await this.preferences?.get(KEY_API, '')
      return apiKey as string
    } catch (err) {
      console.error('获取API Key失败:', err)
      return ''
    }
  }

  // 调用DeepSeek AI API
  async callDeepSeek(question: string, context: string): Promise<string> {
    const apiKey = await this.getApiKey()
    
    if (!apiKey) {
      return '错误：未配置API Key，请先在主页点击"API填写"进行配置。'
    }

    try {
      const httpRequest = http.createHttp()
      
      const systemMessage: ChatMessage = {
        role: 'system',
        content: '你是一个考研学习助手，请帮助用户理解和掌握知识点。'
      }
      
      const userMessage: ChatMessage = {
        role: 'user',
        content: `上下文信息：\n${context}\n\n用户问题：\n${question}`
      }

      const requestBody: ChatRequest = {
        model: 'deepseek-chat',
        messages: [systemMessage, userMessage],
        temperature: 0.7
      }

      console.info('发送DeepSeek请求，API Key长度:', apiKey.length)
      
      const jsonData = JSON.stringify(requestBody)
      console.info('请求数据:', jsonData)
      
      const response = await httpRequest.request(
        'https://api.deepseek.com/v1/chat/completions',
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
          },
          extraData: jsonData,
          expectDataType: http.HttpDataType.STRING,
          connectTimeout: 60000,
          readTimeout: 60000
        }
      )

      httpRequest.destroy()

      console.info('DeepSeek响应码:', response.responseCode)
      if (response.responseCode !== 200) {
        console.error('响应内容:', response.result)
      }

      if (response.responseCode === 200) {
        const result: ChatResponse = JSON.parse(response.result as string) as ChatResponse
        if (result.choices && result.choices.length > 0) {
          return result.choices[0].message.content
        } else {
          return '错误：AI返回数据格式异常'
        }
      } else {
        return `错误：API调用失败 (${response.responseCode})`
      }
    } catch (err) {
      console.error('调用DeepSeek API失败:', err)
      return `错误：网络请求失败 - ${err}`
    }
  }
}

export default new ApiManager()
