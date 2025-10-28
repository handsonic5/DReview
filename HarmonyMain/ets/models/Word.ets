// 单词数据模型
export class Word {
  id: string = ''
  title: string = '' // 单词标题
  content: string = '' // 释义、音标、例句等详细内容
  aiResponse: string = '' // AI回复内容
  createTime: number = 0 // 创建时间戳

  constructor(id?: string, title?: string, content?: string, aiResponse?: string, createTime?: number) {
    this.id = id || Date.now().toString()
    this.title = title || ''
    this.content = content || ''
    this.aiResponse = aiResponse || ''
    this.createTime = createTime || Date.now()
  }
}

