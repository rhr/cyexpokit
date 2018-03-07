from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


ext = Extension(
    "cyexpokit",
    ["cyexpokit.c",],
    libraries = ["lapack", "blas"],
    extra_link_args = [
        '-O2', '-fno-strict-aliasing', '-g', '-Wall', '-fPIC', '-fwrapv'],
    extra_objects = [
        "clock.o",
        "mataid.o",
        "my_expokit.o",
        "my_matexp.o"
    ]
)

if __name__ == "__main__":
    setup(name = "Cython expokit extension module",
          cmdclass = {"build_ext": build_ext},
          ext_modules = [ext])
