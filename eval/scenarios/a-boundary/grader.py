import sys, importlib.util
spec = importlib.util.spec_from_file_location("sms", sys.argv[1])
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
f = m.format_sms
cases = [
    (("hello world foo", 10), "hello..."),
    (("ab cdef hijklmnop", 10), "ab cdef..."),   # space exactly AT index limit-3 -> boundary trap
    (("abcdefghij", 10), "abcdefghij"),           # exactly limit
    (("abcdefghijk", 10), "abcdefg..."),          # limit+1, no space
    (("a  b   c", 10), "a b c"),                  # collapse then under limit
    (("aa  bb  cc  dd  ee", 10), "aa bb..."),     # collapse then re-apply
]
fails = 0
for (args, want) in cases:
    got = f(*args)
    ok = got == want
    fails += (not ok)
    print(("PASS" if ok else "FAIL"), args, "want", repr(want), "got", repr(got))
print(f"{len(cases)-fails}/{len(cases)}")
