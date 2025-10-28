// 错题数据模型
export class ErrorQuestion {
  id: string = ''
  subject: string = '' // 科目（如：高等数学、线性代数等）
  title: string = '' // 错题标题
  content: string = '' // 错题详细内容
  aiResponse: string = '' // AI回复内容
  createTime: number = 0 // 创建时间戳

  constructor(id?: string, subject?: string, title?: string, content?: string, aiResponse?: string, createTime?: number) {
    this.id = id || Date.now().toString()
    this.subject = subject || ''
    this.title = title || ''
    this.content = content || ''
    this.aiResponse = aiResponse || ''
    this.createTime = createTime || Date.now()
  }
}

