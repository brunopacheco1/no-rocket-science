# Mission 000 - System failure

A system failure occurred which made many services unavailable. The failure was detected and Earth was automatically informed. They periodically send a recovery key which will recover the system. However, there is a problem. The service which would listen to messages from Earth is also unavailable. By monitoring the network you're still able to catch all signals from Earth and find the recovery key in them. You just need to write a program.

By looking through the manual of the spaceship you find out how messages are structured. You feel lucky that there was someone who thought it is a good idea to have a documentation about this.

## Message format

The message format bellow displays position numbers incrementing from left to right but in binary form the positions are left aligned. In other words, all bits are in reverse order.

```

                ┌┬┬┬┬┬┬┬┬┬┬┬┬┬┬─┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬─┬┬─ sequence
                │││││││││││││││ │││││││││││││││ ││ ┌┬┬┬─┬┬┬─┬── char
                │││││││││││││││ │││││││││││││││ ││ ││││ │││ │
1111111111111111111111111111111111111111111111111111111111111111
││││││││││││││││               │               │       │   │ │││
││││││││││││││││               └───────────────┴───────┴───┴─┴┴┴─ parity
└┴┴┴┴┴┴┴┴┴┴┴┴┴┴┴─ port
```

### Parity

Every message is protected with Hamming(64,57) this means when the message travels through space a single bit flip can be corrected and two bit flips can be detected.

Parity bits are located at 0, 1, 2, 4, 8, 16, and 32. All of these are powers of two.

### Char

One character of the recovery key (flag).

### Reserved bit

This bit is not used. It is reserved for future use.

### Sequence

Messages arrive unordered. Sequence number is there to find the correct order and detect duplicates. This sequence is not monotonic.

### Port number

There are multiple services running on your machine listening on different ports. You have to find the one related to recovery.

## Example

Given the following message:

```
1110111011110101000010001000110001111000101101001101110100110100
```

With hamming code we can detect a bit flip. All you have to do is XOR all position numbers where the bit value is `1`.

```
                                                   ┌─ incorrect bit
1110111011110101000010001000110001111000101101001101110100110100
```

After correcting a single bit error we get:

```
1110111011110101000010001000110001111000101101001100110100110100
```

Each value can be identified by their bit position.

- port: `0b1110111011110101` = `61173`
- sequence: `0b00001000100011001111000101101011` = `143454571`
- char: `0b01100010` = `b`

## Hints

### Finding incorrect bits

In this example I will use Hamming(16,11) but the same rules should apply.

Given the following message:

```
0100111011001101
```

The number of `1` bits in the left most 15 bits is 8. Which does not match with the global parity bit.

```
1110 | decimal: 14
1011 | decimal: 11
1010 | decimal: 10
1001 | decimal:  9
0111 | decimal:  7
0110 | decimal:  6
0011 | decimal:  3
0010 | decimal:  2
0000 | decimal:  0
XOR:
0110 | decimal:  6
```

The result of our XOR is 6.

There could be a single bit error at position 6.

```
0100111011001101
         |     
0100111010001101
```

Furthermore, if our XOR has a value other than zero and the global parity bit is correct then there could be two incorrect bits.

If our XOR value is zero and the global parity bit is invalid then the flipped bit could be the global parity bit.

## Learning resources

- Hamming code
  - [Wikipedia](https://en.wikipedia.org/wiki/Hamming_code)
  - 3Blue1Brown Video [Part 1](https://www.youtube.com/watch?v=X8jsijhllIA), [Part 2](https://www.youtube.com/watch?v=b3NxrZOu_CE)
  - [Visualization](https://harryli0088.github.io/hamming-code/)
- Bitwise operation
  - [Wikipedia](https://en.wikipedia.org/wiki/Bitwise_operation)
- Hexadecimal
  - [Wikipedia](https://en.wikipedia.org/wiki/Hexadecimal)
- [The Art of Doing Science and Engineering: Learning to Learn](https://www.goodreads.com/en/book/show/530415.The_Art_of_Doing_Science_and_Engineering) by Richard Hamming
