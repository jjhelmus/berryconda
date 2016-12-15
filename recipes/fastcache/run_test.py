from fastcache import clru_cache


@clru_cache(maxsize=325, typed=False)
def fib(n):
    """Terrible Fibonacci number generator."""
    return n if n < 2 else fib(n-1) + fib(n-2)

assert fib(300) == \
    222232244629420445529739893461909967206666939096499764990979600
