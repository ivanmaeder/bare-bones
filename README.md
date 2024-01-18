# Introductory Tutorial For Kernel Development
These are the steps I took following the [Zesterer/Bare Bones](https://wiki.osdev.org/User:Zesterer/Bare_Bones) tutorial.

## Configuration
### Cross-compiler
The steps below are a slightly modified version of [this](https://github.com/dockcross/dockcross).

```bash
docker run --rm dockcross/linux-i686 > ./dockcross
chmod +x ./dockcross
mv ./dockcross ./bin
```

To test the build, try the following (`/work` is the volume into which `.` is mounted). Note that the object file won't run unless you're on the **linux-i686** platform.

```bash
bin/dockcross bash -c '$CC /work/hello.c -o build/hello'
```