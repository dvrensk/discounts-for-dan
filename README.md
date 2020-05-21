# Discounts for Dan

## Assignment:

You are the lead programmer for a small chain of supermarkets. You are required to make a simple cashier function that adds products to a cart and displays the total price.

You have the following test products registered:

| Product code | Name | Price |
| ------------ | ---- | ----: |
| GR1 | Green tea | £3.11 |
| SR1 | Strawberries | £5.00 |
| CF1 | Coffee | £11.23 |

## Special conditions:

* The CEO is a big fan of buy-one-get-one-free offers and of green tea. He wants us to add a rule to do this.
* The COO, though, likes low prices and wants people buying strawberries to get a price discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
* The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop to two thirds of the original price.

Our check-out can scan items in any order, and because the CEO and COO change their minds often, it needs to be flexible regarding our pricing rules.

The interface to our checkout looks like this (shown in ruby):

```ruby
co = Checkout.new(pricing_rules)
co.scan(item)
co.scan(item)
price = co.total
```

**Implement a checkout system that fulfills these requirements.**

*Test data:*

Basket: GR1,SR1,GR1,GR1,CF1 \
Total price expected: ​£22.45

Basket: GR1,GR1 \
Total price expected: ​£3.11

Basket: SR1,SR1,GR1,SR1 \
Total price expected:​ £16.61

Basket: GR1,CF1,SR1,CF1,CF1 \
Total price expected:​ £30.57

## Comments on the implementation

1. I'd probably spend some time trying to talk the CTO out of using fractions.
    Sure, it looks nice and natural, but the cost incurred in the interface is
    non-negligible, and "33 % off" works just as well in marketing as "you only
    pay two thirds the price" if not better.
1. It turns out that `BigDecimal` and `Rational` don't play perfectly together.
    `3 * unit_price * Rational(2, 3)` ought to be _exactly_ equal to
    `2 * unit_price`, but it's not.  So in the end I had to dig out the
    numerator and denominator and do the maths by hand.
1. The `Discount` class/struct is not part of the requirements and could be seen
    as over-engineering, but I think of it as providing some transparency for
    testing as making it easier to follow the flow.
1. The requirement was for "buy-one-get-one-free" but I felt it was more
    natural to implement a `BuyNGetMFree` rule to avoid the magic numbers 1+1.
1. It's a bit unfortunate that using `BigDecimal` means that the specs have to
    be sprinkled with `to_d` or similar.  For a larger implentation I'd create
    some custom rspec matchers.
1. The big gap in the implementation is the lack of support for overlapping
    rules.  On one hand, it's a bit annoying that adding rules could have
    very suprising results, but on the other hand, it's a complex area and
    any speculative work done here is bound to be incomplete.
1. For similar reasons, there is no validation of the rule parameters.
