# my_project_cxx

A pre-made cross-platform workspace for easily writing C++23. This is just a project template.

## What is this?

This is a cross-platform workspace that is set-up with CMake to do the following:
- Allow use of C++20/C++23 modules
- Allow import of the standard library as a module `std`, even though this is not yet (as of writing) officially supported by CMake.
- Automatically link and compile source, header and module files with recursive scanning, inside the `src`-folder.
- Automatically compile tests in the `tests`-folder and run them with CTest.
- Minimum setup required, if the instructions here are followed, it should (hopefully) work almost right out of the box.

The reason i made this was so that students taking a course in modern C++23, who are not very familiar with CMake, can more easily do their homework.

## Support

I'm using this setup on Arch-Linux, and it works great on there.

I also tried it on MacOS Monterey in a VM, and it worked more or less. I did get some linker problems with parts of the standard library, but i suspect this is because i was running MacOS on x86_64 architecture in a virtual machine. There's a good chance it works perfectly fine on a system with ARM architecture.

I've not yet tried this on Windows, and as such the setup is incomplete.

## Setup

### Install prerequesites (any IDE)

For this workspace to function, you need to install CMake, Ninja, Clang, LLD, and libc++. You also need git to clone this repository.

#### Windows

I haven't set this up for Windows yet, but if i were to try to do it, you'd need a different standard library and would probably not be able to do `import std` until CMake supports this officially (supposedly in CMake version 3.30). Any help with making this Windows compatible is greatly appreciated.

Git can be installed from this webpage: https://git-scm.com/downloads.

You can get most of the prerequesites (except `libc++` and i'm not sure about `lld`) from the Visual Studio Tools Installer, from here: https://visualstudio.microsoft.com/downloads/.

You will most definitely have to edit the `CMakeLists.txt` file extensively to make it work.

##### Standard library

On Windows, `libc++` is not available.

Your best options are GCC's `libstdc++` and Microsoft's STL.

STL, as far as i know, is distributed as `.dll` binary files, and would have to be included in a fundamentally different way in the `CMakeLists.txt`. I don't even know where to begin with this. You can get it from the Visual Studio Tools Installer, here: https://visualstudio.microsoft.com/downloads/.

`libstdc++` is also a decent option, and might be easier to set up. Hell, it might even be possible to use it as an importable C++20/C++23 module thorugh CMake with a similar trick that i've done with `libc++`. Worth a try. It can be installed with `MinGW` (https://www.mingw-w64.org/).

#### Arch-Linux (and possibly other distros that use pacman)

With Linux, you have a choice to either use the latest stable, pre-built Clang version (version 19 as of writing) or the latest development/git version (version 21 as of writing) built from source. Building from source can be a bit tricky, takes hours to complete, and requires you to set up the correct environment variables, preferably inside `/etc/makepkg.conf` or an equivalent. It can be a slightly ardous task, but it might be worth the time.

For convenience, you might want an AUR wrapper, for example `yay` or `paru`. If not, you'll need to clone the repo of each AUR package and run `makepkg -si` inside.

Install the following packages from the AUR:
- `git`
- `cmake`
- `ninja`
- For clang version 19 (i recommend installing them together as `yay -S llvm clang compiler-rt`):
    - `llvm`
    - `clang`
    - `compiler-rt`
- For clang version 21 (i recommend installing them together as `yay -S llvm-minimal-git clang-minimal-git`):
    - `llvm-minimal-git` (Don't try to build `llvm-git`. You will run out of disk space. Trust me, i have tried.)
    - `clang-minimal-git`
- `libc++abi`

On other distributions, you need the equivalent of these packages, and the rest should be easy.

If you chose the git version, you might have to manually edit the `std.cppm` and `std.compat.cppm` to remove the failing checks for missing headers that are not yet implemented. Just comment them out.

#### MacOS/OSX

Clang comes pre-installed on MacOS, but it's not a new enough version (as of writing). For this setup i've picked the (at the time of writing) newest available version of Clang for MacOS, `clang-19`. If you later were to use a newer version, the `CMakeLists.txt` will need changes.

1. Install XCode Command Line Developer Tools
    - Open up the terminal
    - `xcode-select --install` (this includes `git`, and is also a requirement for MacPorts to work)
2. Install MacPorts (alternatively, Homebrew can be used)
    - Go to this webpage: https://www.macports.org/install.php
    - Select the correct download link for your version of MacOS
    - An installer will be downloaded. Run this and you're set.
3. On MacOS, the environment variables needed to run a C/C++ compiler are not set by default. Set them in the file `~/.bashrc`
    - Open up the terminal
    - `touch ~/.bashrc`
    - `open ~/.bashrc` (A text editor will now open)
    - In the text editor, add these lines to the bottom of the file:
```bash
export CC=clang
export CXX=clang++
export CMAKE_C_COMPILER=clang
export CMAKE_CXX_COMPILER=clang++
export CXXFLAGS="-cxx-isystem/opt/local/libexec/gcc11/libc++/include/c++/v1"
export CPLUS_INCLUDE_PATH=/opt/libexec/gcc11/libc++/include/c++/v1
export CLANG_DEFAULT_CXX_STDLIB=libc++
```
3. Continuation...
    - Verify that the path to the standard library is correct on your system. If you do `ls /opt/local/libexec/gcc11/libc++/include/c++/v1`, you should see some header files (`.h`), like `stddef.h`, `stdio.h`, and so on. If this is not the case, figure out the correct path to the `libc++` standard library and use that path instead.
    - Save the file `~/.bashrc` (⌘ + S) and close the text-editor window
4. Now you are ready to install a few packages with MacPorts. If you use Homebrew, the command is different, but you still need the equivalent packages. The default shell `zsh` does not use the `~/.bashrc` file, so you need to change shell to `bash` first.
    - `bash` (This enters the shell `bash` instead of `zsh`. Otherwise, the environment variables we set will not be used.)
    - `sudo port install cmake`
    - `sudo port install ninja`
    - `sudo port install procs`
    - `sudo port install clang-19`
    - If any of these fail, check the log file and figure out the problem. Enter `sudo port clean <name of package>` to cleanly rebuild the package after you've done changes elsewhere. If all goes well, you now have all the right prerequesites installed.

### Setting up Visual Studio Code

1. Install VSCode or any equivalent (VSCodium, ...).
    - Arch-Linux: `sudo pacman -S code`
    - Windows/MacOS: Download the installer at https://code.visualstudio.com/.
2. If you haven't already, make a folder for your C++ workspaces. (For example, `~/Code/c++/`)
3. Clone this git repo by entering `git clone https://github.com/sigurd4/my_project_cxx.git` in the terminal while in this directory you just made (do `cd ~/Code/c++` first or any equivalent).
4. Open VSCode in the new folder.
5. A prompt asking you to install recommended extensions might shop up. Click yes, or install them individually in the extensions panel under the `Recommended` tab. Wait for the installation to complete.
6. A new toolbar at the bottom of the screen will appear (from the CMake Tools extension). Click the button that says `No kit selected`, then click `Scan for kits` in the pop-up menu.
7. Click the `No kit selected` button again, and select the newest version you can find of `clang` (not `clang-cl`).

 #### Setting up Clangd in VSCode

Clangd is LLVM's intellisense daemon. It's not strictly needed to write and compile your code, but it sure makes for a better coding experience, with continual compile-checking, intellisense (when you type a '.', a list of suggestions will pop up), and syntax highlighting.

If Clangd shows errors that do not appear when you build your workspace, follow this instruction to possibly fix it. If this fails, see this guide for more ideas: https://clangd.llvm.org/troubleshooting.

For Clangd to function better, it is recommended to add the following lines to your `settings.js`. (Open it by pressing Ctrl + Shift + P or ⌘ + Shift + P to open the run menu, then type "settings json" and you should see the option `Preferences: Open User Settings (JSON)`).

##### Linux
 
```json
    "clangd.path": "/usr/bin/clangd",
    "clangd.arguments": [
        "--query-driver=/usr/bin/clang,/usr/bin/clang++",
        "--target=x86_64-pc-linux-gnu",
        "--background-index=0"
    ]
```

The target triple might possibly vary from system to system.

##### Others

Same as with Linux, but change the paths and the target triple to whatever is correct on your system. My guess would be that `clangd` lies in the same directory as `clang`.

## Thanks to

- User [a858438680](https://github.com/a858438680) for figuring out a reliable workaround to importing the standard library as a module on unix systems. Source: https://github.com/llvm/llvm-project/issues/80231#issuecomment-1922037108. His solution works great, even though CMake does not yet support `import std` (as of writing).
