# 为可测试性设计接口

好的接口使测试自然：

1. **接受依赖，而非创建依赖**

   ```typescript
   // 可测试
   function processOrder(order, paymentGateway) {}

   // 难测试
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **返回结果，而非产生副作用**

   ```typescript
   // 可测试
   function calculateDiscount(cart): Discount {}

   // 难测试
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **精简接口范围**
   - 更少方法 = 需要更少测试
   - 更少参数 = 更简单的测试设置
