# ---2018.7.17中午更新---
目前仍需要完成：
* 删除`InterruptionCode.asm`中的`nop`指令，确保CPU仍然能正常工作
* 完善异常处理代码
* 根据马可的经验，ALU的移位应改为并行计算
* 进一步缩短时序约束的时钟周期，观察Vivado是否能够优化布局
# ---更新结束---


# MIPS_CPU
常用`git`操作，可参考[廖雪峰的教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)
* `git clone git@github.com:IrisLi17/MIPS_CPU.git`将远程仓库克隆到本地
* `git add FILENAME`暂存本地更改
* `git commit -m "YOUR MESSAGE"`将暂存的更改提交到本地分支
* `git status`查看工作区状态
* `git pull origin master`从远程仓库拉取，如果有冲突，手动在本地合并:)
* `git push origin master`将该分支上所有提交推送到远程仓库。建议在`push`之前先`pull`

This project will include:
* ALU
* Single Cycle
* Pipelind
### 正在进行
* ALU编写
* 单周期数据通路搭建
* 对中断的支持
* 定时器和串口与控制单元的连接
