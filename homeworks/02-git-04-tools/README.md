# Домашнее задание к занятию «2.4. Инструменты Git»
1. command: git show aefea <br />commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545 comment Update CHANGELOG.md
1. command: git show 85024d3<br /> v0.12.23
1. command: git show b8d720^ and git show b8d720^2<br /> 
   2 родителя 56cd7859e05c36c06b56d013b55a252d0bb7e158 and 9ea88f22fc6269854151c571162c5bcf958bee2b
1. command: git checkout v0.12.24 and git log --oneline <br />
   33ff1c03b (HEAD, tag: v0.12.24) v0.12.24<br />
   b14b74c49 [Website] vmc provider links<br />
   3f235065b Update CHANGELOG.md<br />
   6ae64e247 registry: Fix panic when server is unreachable<br />
   5c619ca1b website: Remove links to the getting started guide's old location<br />
   06275647e Update CHANGELOG.md<br />
   d5f9411f5 command: Fix bug when using terraform login on Windows<br />
   4b6d06cc5 Update CHANGELOG.md<br />
   dd01a3507 Update CHANGELOG.md<br />
   225466bc3 Cleanup after v0.12.23 release<br />
   85024d310 (tag: v0.12.23) v0.12.23<br />
1. command:  git log -S'func providerSource' <br />
   8c928e835 main: Consult local directories as potential mirrors of providers
1. command: git log -SglobalPluginDirs --oneline<br />
   35a058fb3 main: configure credentials from the CLI config file<br />
   c0b176109 prevent log output during init<br />
   8364383c3 Push plugin discovery down into command package
1. command: git log -SsynchronizedWriters<br />
   Author: Martin Atkins <mart@degeneration.co.uk>

 
