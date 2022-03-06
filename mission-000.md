# Mission 000

A system failure occurred which made many services unavailable. The failure was detected and Earth was automatically informed. They periodically send a recovery key which will recover the system. However, there is a problem. The service which would listen to messages from Earth is also unavailable. By monitoring the network you're still able to catch all signals from Earth and find the recovery key in them. You just need to write a program.

By looking through the manual of the spaceship you find out how messages are structured. You feel lucky that there was someone who thought it is a good idea to have a documentation about this.

## Message format

The message format bellow displays position numbers incrementing from left to right but in binary form the positions are left aligned. In other words, all bits are in reverse order.

```
/---------------------------------------------------------------------------------------------------------------------------------\
| 0                   1                   2                   3                   4                   5                   6       |
| 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 |
|---------------------------------------------------------------------------------------------------------------------------------|
| P P P c P c c c P c c c c x s s P s s s s s s s s s s s s s s s P s s s s s s s s s s s s s s s p p p p p p p p p p p p p p p p |
\---------------------------------------------------------------------------------------------------------------------------------/

P - parity
c - char
x - reserved bit
s - sequence
p - port number
```

### Parity

Every message is protected with Hamming(64,57) this means when the message travels through space a single bit flip can be corrected and two bit flips can be detected.

### Char

One character of the recovery key (flag).

### Reserved bit

This bit is not used. It is reserved for future use.

### Sequence

Messages arrive unordered. You have to use their sequence to find the correct order. This sequence is not monotonic.

### Port number

There are multiple services running on your machine listening on different ports. You have to find the one related to recovery.

## Hints

1. You can use XOR to find the position of the bad bit.
2. Flip of two bits can be detected by the global parity bit.
3. Pure data values from hamming can be sorted based on their integer value. No need for splitting into individual data.
4. The recovery key (flag) contains 32 hexadecimal characters.

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
