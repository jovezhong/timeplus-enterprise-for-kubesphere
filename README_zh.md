Timeplus是一个简单、强大且经济的流处理平台。它提供强大的一站式服务，帮助数据工程师快速、直观地处理流和历史数据。适用不同行业不同规模的数据团队，融合使用 SQL， JavaScript 和 Python 解锁流数据价值。

## 为什么使用 Timeplus ？

### 简单

Timeplus的核心引擎被设计和实现为单个二进制文件，没有诸如JVM，Kubernetes或云服务的任何依赖。 这可以帮助开发人员轻松下载和设置系统，然后轻松管理和扩展系统。 Timeplus SQL 易于学习，Timeplus Console 易于使用。 简单性是该产品的关键 DNA，它使更多的数据团队能够轻松驾驭实时数据。

### 强大

Timeplus为分析实时数据和历史数据提供了独特的解决办法。 正如我们的公司名称所暗示的那样，我们专门为实时数据而生。 Timeplus中的每个查询都被实时新数据而触发，可以检测到延迟事件，您可以选择丢弃或等待它们。 支持常用时间窗口，如固定窗口tubmle、滑动窗口hop、会话窗口session。 您可以联合查询多个流（JOIN），或者通过CSV、S3或数据库来对数据添加上下文。

Timeplus 不仅仅是一个流数据处理器。 它提供端到端的分析功能。 Timeplus 支持其他数据连接，例如 NATS 和 WebSocket。 Timeplus提供了一个用户能够实时交互进行数据分析的网页界面。 提供实时可视化和仪表板。 用户可以将分析结果发送到Apache Kafka等下游数据系统，也可以触发警报，以便用户可以根据流分析结果检测到的异常情况进行实时操作。

### 低成本

Timeplus 用户像Lambda架构的数据栈一样设置和维护多个系统，因为  Timeplus 将流处理和历史数据分析统一到一个系统中。 这可以显著节省成本和降低运维难度。

不同于 Flink，ksqlDB 等流处理工具，Timeplus是用C++语言实现的，它利用了矢量化数据计算能力和现代并行处理技术指令/多数据（SIMD）。 硬件或云成本远低于传统的基于JVM的流处理器。

此外，由于Timeplus非常注重简单性和易用性，因此与Apache Flink或ksqlDB相比，工程师可以花很少的时间就熟练使用 Timeplus。 此外，由于Timeplus易于使用，无需再雇用众多资深工程师来构建流数据分析应用。

## 如何在 KubeSphere 使用 Timeplus ？

### 安装
点击导航栏左上角按钮进入在 KubeSphere 的扩展市场界面。选择最后的“流式计算与消息队列”分类，选择并订阅 Timeplus。选择最新版本的扩展组件。

在配置界面，请注意修改`domain`，设置它为您可以访问的外网 IP 加上`.nio.io`
```yaml
base:
  # 配置为可访问kubesphere部署的域名, 如www.ks.com 或 192.168.50.208.nip.io
  domain: 34.123.122.34.nip.io
```

为了节省系统资源， 默认安装单数据节点，并每个节点配置 10GB 数据存储。如有需要，可以修改`replicas`为 3，这将启动一个 3 数据节点的集群。
```yaml
timeplus-enterprise:
  timeplusd:
    # 设置为 1 为单节点，3 为多节点，暂时不支持 1 和 3 以外的值
    replicas: 1
```
此外，必须调整存储类型。请先运行 `kubectl get storageclass`以获得当前 KubeSphere 对应 Kubernetes 的支持存储类型。然后修改 4 处 `className: local`将 local 改为当前系统支持的存储类型。

每个数据节点的默认大小，如下。也可以做相应更新
```yaml
resources:
  limits:
    cpu: "2"
    memory: "6Gi"
  requests:
    cpu: "1"
    memory: 4Gi
```

### 访问 Timeplus
在调整扩展组件配置并安装后，请稍等片刻。系统将拉取对应镜像并初始化系统。您可以通过以下命令查看
```
kubectl get po -n extension-timeplus-enterprise
```
如果带有`timeplus-provision-`前缀的pod 已经Completed 且其他4 个`timeplus`前缀的 pod 都处于 Running状态（如果是 3 节点集群，则总共 6 个 Running Pod），这表示 Timeplus Enterprise 启动完成。

点击左上角的 Timeplus 按钮，KubeSphere 将打开一个新的浏览器标签页来显示 Timeplus 界面。

### 使用 Timeplus
第一步，您需要创建一个管理员用户，输入 email，username，password 信息，提交后用该用户名密码登录。

选择数据摄取界面（左边导航栏第二条），选择连接 Kafka 等数据源。也可以选择第一个选项来生成实时数据来体验流数据查询。

### 激活 Timeplus 许可证
新安装的 Timeplus Enterprise 提供 30 天全功能免费试用。如需购买许可证继续使用或扩大集群规模，请致函 info@timeplus.com 或联系您的 Timeplus 客户经理。

### 卸载和删除
如您不再需要试用 Timeplus，可以通过 KubeSphere 的管理界面卸载这一扩展组件。卸载后，请手动清空存储盘。可以通过以下命令查看
```sh
kubectl get pvc -n extension-timeplus-enterprise
```
然后一一删除
```sh
k delete pvc timeplusd-history-timeplusd-0 timeplusd-stream-timeplusd-0 kv-data-kv-0 -n extension-timeplus-enterprise
```
如有任何意见建议，欢迎致函 info@timeplus.com 或联系您的 Timeplus 客户经理。

Timeplus 核心引擎使用 Apache 2.0 License 开源。https://github.com/timeplus-io/proton 欢迎加星关注并讨论。
