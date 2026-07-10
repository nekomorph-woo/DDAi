# 好测试与坏测试

## 好测试

**集成风格**：通过真实接口测试，而非内部 mock。

```typescript
// 好：测试可观察行为
test("用户可用有效购物车结账", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特征：

- 测试用户/调用者关心的行为
- 仅使用公共 API
- 经受内部重构
- 描述做什么，而非怎么做
- 每个测试一个逻辑断言

## 坏测试

**实现细节测试**：与内部结构耦合。

```typescript
// 坏：测试实现细节
test("结账调用 paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

危险信号：

- Mock 内部协作者
- 测试私有方法
- 断言调用次数/顺序
- 行为未变的重构导致测试失败
- 测试名描述怎么做而非做什么
- 通过外部手段而非接口验证

```typescript
// 坏：绕过接口验证
test("createUser 保存到数据库", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// 好：通过接口验证
test("createUser 使创建的用户可被检索", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

## 系统边界 vs 内部协作者

| 类型 | 示例 | 是否 mock |
|------|------|-----------|
| 系统边界 | Repository、PaymentGateway、EmailService | ✅ 可以 mock |
| 内部协作者 | PriceCalculator、DiscountApplier | ❌ 跑真实逻辑 |

**原因**：测试目的是验证业务行为是否正确。mock 内部计算，等于跳过了要验证的逻辑。

## 三层覆盖原则

代码模式下，测试覆盖按三层组织（与 plan step 的测试覆盖声明对齐）：

| 层 | 目的 | 典型场景 |
|----|------|----------|
| 正常路径 | 验证主逻辑路径 | "用户用有效输入结账成功" |
| 边界条件 | 验证输入/状态边界 | "购物车为空时结账返回提示" / "库存为 0 时拒绝下单" |
| 异常路径 | 验证错误/失败场景 | "支付网关超时返回友好错误" / "未登录访问受保护资源返回 401" |

**原则**：
- 每层至少一个测试，通过公共接口验证可观察行为
- 优先级：plan 测试覆盖声明 > 验收标准 > 自行识别
- 测试名描述行为，不描述实现（参见"好测试"section）
- 三层互补，不可互相替代——正常路径通过不代表边界/异常覆盖
