// 数据管理类 - 负责本地数据持久化
import dataPreferences from '@ohos.data.preferences'
import { Word } from '../models/Word'
import { ErrorQuestion } from '../models/ErrorQuestion'

const PREFERENCES_NAME = 'DrAppData'
const KEY_WORDS = 'words'
const KEY_ERRORS = 'errors'

class DataManager {
  private preferences: dataPreferences.Preferences | null = null

  // 初始化数据存储
  async init(context: Context): Promise<void> {
    try {
      if (this.preferences) {
        console.info('DataManager already initialized')
        return
      }
      this.preferences = await dataPreferences.getPreferences(context, PREFERENCES_NAME)
      console.info('DataManager initialized successfully')
      
      // 检查并添加初始数据
      await this.initDefaultData()
    } catch (err) {
      console.error('初始化数据存储失败:', err)
    }
  }

  // 初始化默认数据（仅在首次启动时）
  private async initDefaultData(): Promise<void> {
    try {
      // 检查是否已有数据
      const words = await this.getWords()
      const errors = await this.getErrors()
      
      // 如果已有数据，不再初始化
      if (words.length > 0 || errors.length > 0) {
        console.info('已存在数据，跳过初始化')
        return
      }
      
      console.info('首次启动，初始化默认数据...')
      
      // 初始化单词数据
      await this.initDefaultWords()
      
      // 初始化错题数据
      await this.initDefaultErrors()
      
      console.info('默认数据初始化完成')
    } catch (err) {
      console.error('初始化默认数据失败:', err)
    }
  }

  // 初始化默认单词
  private async initDefaultWords(): Promise<void> {
    const defaultWords: Word[] = [
      new Word(
        Date.now().toString() + '_1',
        'abandon',
        '释义：v. 放弃；抛弃；离弃\n' +
        '音标：/əˈbændən/\n' +
        '例句：\n' +
        '1. We had to abandon the car and walk the rest of the way.\n' +
        '   我们只好弃车，步行完成剩下的路程。\n' +
        '2. Never abandon hope in face of difficulties.\n' +
        '   面对困难永远不要放弃希望。\n' +
        '词根：from French "a bandon" = at one\'s disposal',
        ''
      ),
      new Word(
        Date.now().toString() + '_2',
        'ambiguous',
        '释义：adj. 模棱两可的；含糊不清的\n' +
        '音标：/æmˈbɪɡjuəs/\n' +
        '例句：\n' +
        '1. Her answer was ambiguous, so I couldn\'t tell if she agreed.\n' +
        '   她的回答模棱两可，我无法判断她是否同意。\n' +
        '2. The treaty is deliberately ambiguous to allow flexibility.\n' +
        '   条约故意含糊其辞以保持灵活性。\n' +
        '同义词：vague, unclear, equivocal\n' +
        '反义词：clear, explicit, unambiguous',
        ''
      )
    ]
    
    for (const word of defaultWords) {
      await this.saveWord(word)
    }
    console.info('默认单词初始化完成，共', defaultWords.length, '个')
  }

  // 初始化默认错题
  private async initDefaultErrors(): Promise<void> {
    const defaultErrors: ErrorQuestion[] = [
      // 高等数学
      new ErrorQuestion(
        Date.now().toString() + '_math1',
        '高等数学',
        '求极限：lim(x→0) sin(x)/x',
        '题目：求 lim(x→0) sin(x)/x 的值\n\n' +
        '解答：\n' +
        '方法一：洛必达法则\n' +
        'lim(x→0) sin(x)/x = lim(x→0) cos(x)/1 = 1\n\n' +
        '方法二：泰勒展开\n' +
        'sin(x) = x - x³/3! + x⁵/5! - ...\n' +
        'sin(x)/x = 1 - x²/3! + x⁴/5! - ...\n' +
        '当 x→0 时，结果为 1\n\n' +
        '错误原因：之前忘记了这是一个重要极限公式，需要牢记。',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_math2',
        '高等数学',
        '求定积分：∫₀¹ x²dx',
        '题目：计算定积分 ∫₀¹ x²dx\n\n' +
        '解答步骤：\n' +
        '1. 求不定积分：∫ x²dx = x³/3 + C\n' +
        '2. 应用牛顿-莱布尼茨公式：\n' +
        '   ∫₀¹ x²dx = [x³/3]₀¹ = 1³/3 - 0³/3 = 1/3\n\n' +
        '答案：1/3\n\n' +
        '注意事项：\n' +
        '- 计算时要注意上下限\n' +
        '- 记住幂函数积分公式：∫ xⁿdx = x^(n+1)/(n+1) + C',
        ''
      ),
      
      // 线性代数
      new ErrorQuestion(
        Date.now().toString() + '_linear1',
        '线性代数',
        '求2阶矩阵的行列式',
        '题目：求矩阵 A = |2  3| 的行列式\n' +
        '              |1  4|\n\n' +
        '解答：\n' +
        '|A| = 2×4 - 3×1 = 8 - 3 = 5\n\n' +
        '公式：对于2阶矩阵 |a  b|\n' +
        '              |c  d|\n' +
        '行列式 = ad - bc\n\n' +
        '易错点：减法顺序不要搞反了',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_linear2',
        '线性代数',
        '判断向量组的线性相关性',
        '题目：判断向量组 α₁=(1,2,3), α₂=(2,4,6), α₃=(1,0,1) 是否线性相关\n\n' +
        '解答：\n' +
        '观察可知 α₂ = 2α₁\n' +
        '因此 α₁ 和 α₂ 线性相关\n' +
        '所以整个向量组线性相关\n\n' +
        '结论：线性相关\n\n' +
        '知识点：\n' +
        '- 如果向量组中有一个向量可以被其他向量线性表示，则线性相关\n' +
        '- 如果有成比例的向量，必然线性相关',
        ''
      ),
      
      // 概率论
      new ErrorQuestion(
        Date.now().toString() + '_prob1',
        '概率论',
        '古典概型：摸球问题',
        '题目：袋中有5个红球和3个白球，随机摸出2个球，求恰好1红1白的概率。\n\n' +
        '解答：\n' +
        '总的取法：C₈² = 28\n' +
        '1红1白的取法：C₅¹ × C₃¹ = 5 × 3 = 15\n' +
        '概率 P = 15/28\n\n' +
        '答案：15/28\n\n' +
        '易错点：之前忘记乘法原理，只算了C₅¹',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_prob2',
        '概率论',
        '正态分布的性质',
        '题目：若 X~N(μ, σ²)，求 P(μ-σ < X < μ+σ)\n\n' +
        '解答：\n' +
        '这是正态分布的3σ原则：\n' +
        '- P(μ-σ < X < μ+σ) ≈ 0.6827\n' +
        '- P(μ-2σ < X < μ+2σ) ≈ 0.9545\n' +
        '- P(μ-3σ < X < μ+3σ) ≈ 0.9973\n\n' +
        '答案：约 68.27%\n\n' +
        '重点：这个要记住，考试常用！',
        ''
      ),
      
      // 计组
      new ErrorQuestion(
        Date.now().toString() + '_arch1',
        '计组',
        'CPU的基本组成',
        '题目：简述CPU的基本组成部分及其功能。\n\n' +
        '解答：\n' +
        'CPU主要由以下部分组成：\n\n' +
        '1. 运算器（ALU）\n' +
        '   - 算术运算（加减乘除）\n' +
        '   - 逻辑运算（与或非等）\n\n' +
        '2. 控制器（CU）\n' +
        '   - 指令译码\n' +
        '   - 发出控制信号\n' +
        '   - 协调各部件工作\n\n' +
        '3. 寄存器组\n' +
        '   - 通用寄存器\n' +
        '   - 专用寄存器（PC、IR、MAR、MDR等）\n\n' +
        '4. 内部总线\n' +
        '   - 连接各部件',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_arch2',
        '计组',
        '存储器的层次结构',
        '题目：说明计算机存储系统的层次结构，从快到慢排列。\n\n' +
        '解答（从快到慢、从小到大）：\n\n' +
        '1. 寄存器（CPU内部）\n' +
        '   - 速度最快、容量最小、价格最贵\n' +
        '   - 访问时间：<1ns\n\n' +
        '2. Cache（高速缓存）\n' +
        '   - L1 Cache、L2 Cache、L3 Cache\n' +
        '   - 访问时间：几ns\n\n' +
        '3. 主存（内存）\n' +
        '   - RAM（DRAM）\n' +
        '   - 访问时间：几十ns\n\n' +
        '4. 辅存（外存）\n' +
        '   - 硬盘、SSD\n' +
        '   - 访问时间：ms级别\n\n' +
        '规律：速度越快，容量越小，价格越贵',
        ''
      ),
      
      // 计网
      new ErrorQuestion(
        Date.now().toString() + '_network1',
        '计网',
        'OSI七层模型',
        '题目：列出OSI七层模型，并说明每层的主要功能。\n\n' +
        '解答（从上到下）：\n\n' +
        '7. 应用层\n' +
        '   - 为应用程序提供网络服务\n' +
        '   - 协议：HTTP、FTP、SMTP、DNS\n\n' +
        '6. 表示层\n' +
        '   - 数据格式转换、加密解密\n\n' +
        '5. 会话层\n' +
        '   - 建立、管理、终止会话\n\n' +
        '4. 传输层\n' +
        '   - 端到端通信、流量控制\n' +
        '   - 协议：TCP、UDP\n\n' +
        '3. 网络层\n' +
        '   - 路由选择、IP地址\n' +
        '   - 协议：IP、ICMP\n\n' +
        '2. 数据链路层\n' +
        '   - 帧传输、MAC地址\n' +
        '   - 协议：以太网、PPP\n\n' +
        '1. 物理层\n' +
        '   - 比特流传输\n' +
        '   - 物理介质、电气特性',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_network2',
        '计网',
        'TCP三次握手过程',
        '题目：详细说明TCP三次握手的过程。\n\n' +
        '解答：\n\n' +
        '第一次握手：\n' +
        '客户端 → 服务器：SYN=1, seq=x\n' +
        '- 客户端发送连接请求\n' +
        '- 进入SYN_SENT状态\n\n' +
        '第二次握手：\n' +
        '服务器 → 客户端：SYN=1, ACK=1, seq=y, ack=x+1\n' +
        '- 服务器确认客户端请求\n' +
        '- 同时发送自己的连接请求\n' +
        '- 进入SYN_RCVD状态\n\n' +
        '第三次握手：\n' +
        '客户端 → 服务器：ACK=1, seq=x+1, ack=y+1\n' +
        '- 客户端确认服务器请求\n' +
        '- 双方进入ESTABLISHED状态\n' +
        '- 连接建立成功\n\n' +
        '为什么需要三次？\n' +
        '- 防止旧连接请求突然传到服务器\n' +
        '- 确认双方收发能力正常',
        ''
      ),
      
      // 数据结构
      new ErrorQuestion(
        Date.now().toString() + '_ds1',
        '数据结构',
        '二叉树的遍历',
        '题目：给定二叉树：\n' +
        '      1\n' +
        '     / \\\n' +
        '    2   3\n' +
        '   / \\\n' +
        '  4   5\n\n' +
        '写出前序、中序、后序遍历结果。\n\n' +
        '解答：\n\n' +
        '前序遍历（根-左-右）：1 2 4 5 3\n' +
        '- 先访问根节点\n' +
        '- 再遍历左子树\n' +
        '- 最后遍历右子树\n\n' +
        '中序遍历（左-根-右）：4 2 5 1 3\n' +
        '- 先遍历左子树\n' +
        '- 再访问根节点\n' +
        '- 最后遍历右子树\n\n' +
        '后序遍历（左-右-根）：4 5 2 3 1\n' +
        '- 先遍历左子树\n' +
        '- 再遍历右子树\n' +
        '- 最后访问根节点\n\n' +
        '口诀：前中后指的是根节点的访问顺序',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_ds2',
        '数据结构',
        '快速排序的时间复杂度',
        '题目：分析快速排序的时间复杂度。\n\n' +
        '解答：\n\n' +
        '最好情况：O(n log n)\n' +
        '- 每次都平分数组\n' +
        '- 递归深度 log n\n' +
        '- 每层需要 O(n) 时间\n\n' +
        '平均情况：O(n log n)\n' +
        '- 大多数情况下表现良好\n\n' +
        '最坏情况：O(n²)\n' +
        '- 每次只分出1个元素（已排序的数组）\n' +
        '- 递归深度 n\n' +
        '- 总时间 O(n²)\n\n' +
        '空间复杂度：O(log n)\n' +
        '- 递归调用栈\n\n' +
        '优化方法：\n' +
        '- 随机选择pivot\n' +
        '- 三数取中法\n' +
        '- 小数组用插入排序',
        ''
      ),
      
      // 计算机系统
      new ErrorQuestion(
        Date.now().toString() + '_sys1',
        '计算机系统',
        '进程和线程的区别',
        '题目：说明进程和线程的主要区别。\n\n' +
        '解答：\n\n' +
        '1. 定义\n' +
        '   - 进程：资源分配的基本单位\n' +
        '   - 线程：CPU调度的基本单位\n\n' +
        '2. 资源开销\n' +
        '   - 进程：创建、切换开销大\n' +
        '   - 线程：创建、切换开销小\n\n' +
        '3. 资源共享\n' +
        '   - 进程：独立的地址空间，资源不共享\n' +
        '   - 线程：共享进程的地址空间和资源\n\n' +
        '4. 通信方式\n' +
        '   - 进程：IPC（管道、消息队列、共享内存等）\n' +
        '   - 线程：直接读写进程数据\n\n' +
        '5. 崩溃影响\n' +
        '   - 进程：一个进程崩溃不影响其他进程\n' +
        '   - 线程：一个线程崩溃可能导致整个进程崩溃\n\n' +
        '总结：线程是轻量级的进程',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_sys2',
        '计算机系统',
        '死锁的四个必要条件',
        '题目：列举并解释死锁的四个必要条件。\n\n' +
        '解答：\n\n' +
        '死锁的四个必要条件（缺一不可）：\n\n' +
        '1. 互斥条件（Mutual Exclusion）\n' +
        '   - 资源不能被多个进程同时使用\n' +
        '   - 一次只能被一个进程占用\n\n' +
        '2. 占有和等待（Hold and Wait）\n' +
        '   - 进程已持有至少一个资源\n' +
        '   - 同时又在等待获取其他资源\n\n' +
        '3. 不可剥夺（No Preemption）\n' +
        '   - 资源不能被强制性剥夺\n' +
        '   - 只能由持有者主动释放\n\n' +
        '4. 循环等待（Circular Wait）\n' +
        '   - 存在进程资源的循环等待链\n' +
        '   - P1等P2，P2等P3，...，Pn等P1\n\n' +
        '预防死锁：\n' +
        '- 破坏四个条件中的任意一个\n' +
        '- 常用方法：破坏循环等待（资源有序分配）',
        ''
      ),
      
      // 马原
      new ErrorQuestion(
        Date.now().toString() + '_marx1',
        '马原',
        '物质和意识的辩证关系',
        '题目：阐述物质和意识的辩证关系。\n\n' +
        '解答：\n\n' +
        '一、物质决定意识（物质第一性）\n' +
        '1. 意识是物质世界长期发展的产物\n' +
        '2. 意识是人脑的机能\n' +
        '3. 意识是客观存在的主观映像\n\n' +
        '二、意识对物质具有能动作用\n' +
        '1. 意识活动具有目的性和计划性\n' +
        '2. 意识活动具有创造性\n' +
        '3. 意识通过实践改造客观世界\n' +
        '4. 意识还能调控人的行为和生理活动\n\n' +
        '三、方法论意义\n' +
        '1. 坚持一切从实际出发\n' +
        '2. 充分发挥主观能动性\n' +
        '3. 把尊重客观规律和发挥主观能动性结合起来\n\n' +
        '记忆口诀：物质决定，意识能动',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_marx2',
        '马原',
        '矛盾的普遍性和特殊性',
        '题目：说明矛盾的普遍性和特殊性及其关系。\n\n' +
        '解答：\n\n' +
        '一、矛盾的普遍性（共性）\n' +
        '1. 矛盾存在于一切事物中\n' +
        '2. 矛盾贯穿于每一事物发展过程的始终\n' +
        '3. 时时有矛盾，处处有矛盾\n\n' +
        '二、矛盾的特殊性（个性）\n' +
        '1. 不同事物的矛盾各有特点\n' +
        '2. 同一事物的矛盾在不同发展阶段各有特点\n' +
        '3. 事物矛盾的双方各有特点\n\n' +
        '三、二者的关系\n' +
        '1. 普遍性寓于特殊性之中\n' +
        '2. 特殊性包含普遍性\n' +
        '3. 相互联结、相互转化\n\n' +
        '四、方法论意义\n' +
        '1. 普遍性→特殊性：演绎法\n' +
        '2. 特殊性→普遍性：归纳法\n' +
        '3. 坚持具体问题具体分析\n\n' +
        '这是马克思主义中国化的哲学基础！',
        ''
      ),
      
      // 毛特
      new ErrorQuestion(
        Date.now().toString() + '_mao1',
        '毛特',
        '新民主主义革命的总路线',
        '题目：简述新民主主义革命的总路线。\n\n' +
        '解答：\n\n' +
        '总路线（1948年提出）：\n' +
        '"无产阶级领导的，人民大众的，反对帝国主义、封建主义和官僚资本主义的革命。"\n\n' +
        '关键词解析：\n\n' +
        '1. 革命领导：无产阶级\n' +
        '   - 通过中国共产党实现\n' +
        '   - 这是革命成功的根本保证\n\n' +
        '2. 革命动力：人民大众\n' +
        '   - 工人阶级\n' +
        '   - 农民阶级\n' +
        '   - 城市小资产阶级\n' +
        '   - 民族资产阶级\n\n' +
        '3. 革命对象：三座大山\n' +
        '   - 帝国主义\n' +
        '   - 封建主义\n' +
        '   - 官僚资本主义\n\n' +
        '4. 革命性质：新民主主义革命\n' +
        '   - 不是旧民主主义革命\n' +
        '   - 也不是社会主义革命\n\n' +
        '意义：指明了革命方向和任务',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_mao2',
        '毛特',
        '社会主义改造的基本完成',
        '题目：说明社会主义改造基本完成的标志和意义。\n\n' +
        '解答：\n\n' +
        '一、时间：1956年\n\n' +
        '二、内容（三大改造）\n' +
        '1. 农业的社会主义改造\n' +
        '   - 互助组→初级社→高级社\n\n' +
        '2. 手工业的社会主义改造\n' +
        '   - 供销合作→生产合作\n\n' +
        '3. 资本主义工商业的社会主义改造\n' +
        '   - 和平赎买政策\n' +
        '   - 公私合营\n\n' +
        '三、标志\n' +
        '- 生产资料私有制转变为社会主义公有制\n\n' +
        '四、重大意义\n' +
        '1. 实现了中国历史上最深刻的社会变革\n' +
        '2. 社会主义基本制度在中国确立\n' +
        '3. 为中国社会主义建设奠定了基础\n' +
        '4. 丰富和发展了马克思主义\n\n' +
        '五、经验教训\n' +
        '- 成功：和平改造，避免了社会动荡\n' +
        '- 教训：后期要求过急，工作过粗',
        ''
      ),
      
      // 史纲
      new ErrorQuestion(
        Date.now().toString() + '_history1',
        '史纲',
        '五四运动的历史意义',
        '题目：论述五四运动的历史意义。\n\n' +
        '解答：\n\n' +
        '一、背景\n' +
        '时间：1919年5月4日\n' +
        '导火索：巴黎和会外交失败\n\n' +
        '二、性质\n' +
        '彻底的反帝反封建的爱国运动\n\n' +
        '三、历史意义\n\n' +
        '1. 新民主主义革命的开端\n' +
        '   - 标志中国革命进入新阶段\n\n' +
        '2. 促进了马克思主义在中国的传播\n' +
        '   - 马克思主义成为主流思想\n' +
        '   - 为中共成立奠定思想基础\n\n' +
        '3. 促进了马克思主义与工人运动的结合\n' +
        '   - 工人阶级登上历史舞台\n' +
        '   - 显示了工人阶级的力量\n\n' +
        '4. 促进了中国共产党的成立\n' +
        '   - 为党的成立做了思想、干部准备\n\n' +
        '四、口号\n' +
        '"外争主权，内除国贼"\n' +
        '"废除二十一条"\n\n' +
        '五、结果\n' +
        '取得初步胜利：\n' +
        '- 罢免卖国贼\n' +
        '- 拒签和约',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_history2',
        '史纲',
        '遵义会议的历史地位',
        '题目：说明遵义会议的主要内容和历史地位。\n\n' +
        '解答：\n\n' +
        '一、时间地点\n' +
        '1935年1月，贵州遵义\n\n' +
        '二、历史背景\n' +
        '红军长征途中，第五次反"围剿"失败\n' +
        '王明"左"倾错误导致重大损失\n\n' +
        '三、主要内容\n' +
        '1. 集中解决军事和组织问题\n' +
        '2. 批判了博古、李德的错误\n' +
        '3. 肯定了毛泽东的正确主张\n' +
        '4. 选举毛泽东为政治局常委\n\n' +
        '四、历史意义（重点！）\n\n' +
        '1. 生死攸关的转折点\n' +
        '   - 挽救了党\n' +
        '   - 挽救了红军\n' +
        '   - 挽救了中国革命\n\n' +
        '2. 开始确立毛泽东的领导地位\n' +
        '   - 实际确立了以毛泽东为核心的党中央正确领导\n\n' +
        '3. 党独立自主解决问题的开始\n' +
        '   - 不依赖共产国际\n' +
        '   - 独立解决中国革命问题\n\n' +
        '4. 标志党在政治上走向成熟\n\n' +
        '记忆：遵义会议是党历史上一个生死攸关的转折点',
        ''
      ),
      
      // 新思想
      new ErrorQuestion(
        Date.now().toString() + '_xi1',
        '新思想',
        '新时代的主要矛盾',
        '题目：说明新时代我国社会主要矛盾的变化。\n\n' +
        '解答：\n\n' +
        '一、提出时间\n' +
        '2017年党的十九大\n\n' +
        '二、主要矛盾的新表述\n' +
        '"人民日益增长的美好生活需要和不平衡不充分的发展之间的矛盾"\n\n' +
        '三、与过去的对比\n\n' +
        '旧表述（1981-2017）：\n' +
        '"人民日益增长的物质文化需要同落后的社会生产之间的矛盾"\n\n' +
        '变化点：\n' +
        '1. 需要方面：\n' +
        '   物质文化需要 → 美好生活需要\n' +
        '   （更高层次、更全面）\n\n' +
        '2. 供给方面：\n' +
        '   落后的社会生产 → 不平衡不充分的发展\n' +
        '   （已不是"落后"的问题）\n\n' +
        '四、深刻内涵\n\n' +
        '美好生活需要：\n' +
        '- 不仅有物质文化需求\n' +
        '- 还有民主、法治、公平、正义、安全、环境等方面的需求\n\n' +
        '不平衡不充分：\n' +
        '- 不平衡：城乡、区域、收入分配等\n' +
        '- 不充分：发展质量和效益不高\n\n' +
        '五、意义\n' +
        '- 反映了我国发展的阶段性变化\n' +
        '- 明确了解决问题的方向\n' +
        '- 为政策制定提供依据',
        ''
      ),
      new ErrorQuestion(
        Date.now().toString() + '_xi2',
        '新思想',
        '五位一体总体布局',
        '题目：阐述"五位一体"总体布局的内容。\n\n' +
        '解答：\n\n' +
        '"五位一体"总体布局：\n' +
        '经济建设、政治建设、文化建设、社会建设、生态文明建设\n\n' +
        '一、经济建设（基础）\n' +
        '- 坚持新发展理念\n' +
        '- 建设现代化经济体系\n' +
        '- 推动高质量发展\n\n' +
        '二、政治建设（保障）\n' +
        '- 坚持党的领导\n' +
        '- 人民当家作主\n' +
        '- 依法治国有机统一\n\n' +
        '三、文化建设（灵魂）\n' +
        '- 坚持社会主义核心价值观\n' +
        '- 建设文化强国\n' +
        '- 提高文化软实力\n\n' +
        '四、社会建设（条件）\n' +
        '- 保障和改善民生\n' +
        '- 促进社会公平正义\n' +
        '- 加强和创新社会治理\n\n' +
        '五、生态文明建设（根基）\n' +
        '- 绿水青山就是金山银山\n' +
        '- 建设美丽中国\n' +
        '- 实现人与自然和谐共生\n\n' +
        '关系：\n' +
        '- 经济建设是中心\n' +
        '- 其他四个建设相互促进\n' +
        '- 共同构成中国特色社会主义事业总体布局\n\n' +
        '记忆技巧：经政文社生（谐音：惊正文社生）',
        ''
      )
    ]
    
    for (const error of defaultErrors) {
      await this.saveError(error)
    }
    console.info('默认错题初始化完成，共', defaultErrors.length, '个')
  }

  // ========== 单词管理 ==========
  
  // 获取所有单词
  async getWords(): Promise<Word[]> {
    try {
      const data = await this.preferences?.get(KEY_WORDS, '[]')
      const words: Word[] = JSON.parse(data as string) as Word[]
      return words.map((w: Word) => new Word(w.id, w.title, w.content, w.aiResponse, w.createTime))
    } catch (err) {
      console.error('获取单词失败:', err)
      return []
    }
  }

  // 保存单词
  async saveWord(word: Word): Promise<boolean> {
    try {
      if (!this.preferences) {
        console.error('DataManager not initialized')
        return false
      }
      
      const words = await this.getWords()
      const index = words.findIndex(w => w.id === word.id)
      if (index >= 0) {
        words[index] = word
        console.info('更新单词:', word.title)
      } else {
        words.push(word)
        console.info('新增单词:', word.title)
      }
      
      const jsonData = JSON.stringify(words)
      console.info('保存单词数据，总数:', words.length)
      
      await this.preferences.put(KEY_WORDS, jsonData)
      await this.preferences.flush()
      
      console.info('单词保存成功')
      return true
    } catch (err) {
      console.error('保存单词失败:', err)
      return false
    }
  }

  // 删除单词
  async deleteWord(id: string): Promise<boolean> {
    try {
      const words = await this.getWords()
      const filtered = words.filter(w => w.id !== id)
      await this.preferences?.put(KEY_WORDS, JSON.stringify(filtered))
      await this.preferences?.flush()
      return true
    } catch (err) {
      console.error('删除单词失败:', err)
      return false
    }
  }

  // 根据ID获取单词
  async getWordById(id: string): Promise<Word | null> {
    const words = await this.getWords()
    return words.find(w => w.id === id) || null
  }

  // ========== 错题管理 ==========

  // 获取所有错题
  async getErrors(): Promise<ErrorQuestion[]> {
    try {
      const data = await this.preferences?.get(KEY_ERRORS, '[]')
      const errors: ErrorQuestion[] = JSON.parse(data as string) as ErrorQuestion[]
      return errors.map((e: ErrorQuestion) =>
        new ErrorQuestion(e.id, e.subject, e.title, e.content, e.aiResponse, e.createTime))
    } catch (err) {
      console.error('获取错题失败:', err)
      return []
    }
  }

  // 获取指定科目的错题
  async getErrorsBySubject(subject: string): Promise<ErrorQuestion[]> {
    const errors = await this.getErrors()
    return errors.filter(e => e.subject === subject)
  }

  // 保存错题
  async saveError(error: ErrorQuestion): Promise<boolean> {
    try {
      if (!this.preferences) {
        console.error('DataManager not initialized')
        return false
      }
      
      const errors = await this.getErrors()
      const index = errors.findIndex(e => e.id === error.id)
      if (index >= 0) {
        errors[index] = error
        console.info('更新错题:', error.title, '科目:', error.subject)
      } else {
        errors.push(error)
        console.info('新增错题:', error.title, '科目:', error.subject)
      }
      
      const jsonData = JSON.stringify(errors)
      console.info('保存错题数据，总数:', errors.length)
      
      await this.preferences.put(KEY_ERRORS, jsonData)
      await this.preferences.flush()
      
      console.info('错题保存成功')
      return true
    } catch (err) {
      console.error('保存错题失败:', err)
      return false
    }
  }

  // 删除错题
  async deleteError(id: string): Promise<boolean> {
    try {
      const errors = await this.getErrors()
      const filtered = errors.filter(e => e.id !== id)
      await this.preferences?.put(KEY_ERRORS, JSON.stringify(filtered))
      await this.preferences?.flush()
      return true
    } catch (err) {
      console.error('删除错题失败:', err)
      return false
    }
  }

  // 根据ID获取错题
  async getErrorById(id: string): Promise<ErrorQuestion | null> {
    const errors = await this.getErrors()
    return errors.find(e => e.id === id) || null
  }
}

export default new DataManager()

