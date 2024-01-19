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

To test the build, try the following (`/work` is the volume into which `.` is mounted). Note that the object file will only run on **linux-i686**.

```bash
bin/dockcross bash -c '$CC /work/hello.c -o build/hello'
```

### Code
For ASM syntax highlighting, I installed [this](https://marketplace.visualstudio.com/items?itemName=basdp.language-gas-x86) Visual Studio Code plugin.