# CENG3010-final

# TODO

- [ ] rewrite keypad2.vhd so it sends it all in one go instead of multiple times without really finishing
- [x] fix the issue with requiring the first input twice
- [x] fix the double reset problem (these two seem like they might be connected) (they were)
- [x] fix the issue where you can enter without a password after clearing a successful opening
- [ ] slap some stickers on the keypad (avoids rewriting keypad2)
    - [ ] find someone with good handwriting to label the stickers
- [x] reorder servo activation to lock-door-door-lock instead of lock-door-lock-door
- [ ] finish password changing in password.vhd
- [x] implement multiple passwords (probably needs state machine) (nah, just needed to disable the door0 sequence while checking the inner doors)
