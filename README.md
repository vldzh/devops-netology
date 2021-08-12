

В виде результата напишите текстом ответы на вопросы и каким образом эти ответы были получены.

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
```
aefead2207ef7e2aa5dc81a34aedf0cad4c32545
"Update CHANGELOG.md"

root@ovpn1:~/devops-netology/terraform# git show --pretty=format:"%H -> %s" --no-patch aefea
aefead2207ef7e2aa5dc81a34aedf0cad4c32545 -> Update CHANGELOG.md
```

2. Какому тегу соответствует коммит 85024d3?
```
(tag: v0.12.23)

root@ovpn1:~/devops-netology/terraform# git show --pretty=format:"%d" --no-patch 85024d3
 (tag: v0.12.23)
```

3. Сколько родителей у коммита b8d720? Напишите их хеши.
2
56cd7859e 9ea88f22f
```
root@ovpn1:~/devops-netology/terraform# git show b8d720
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: 56cd7859e 9ea88f22f
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Jan 21 17:45:48 2020 -0800

    Merge pull request #23916 from hashicorp/cgriggs01-stable

    [Cherrypick] community links
```
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
```
root@ovpn1:~/devops-netology/terraform# git log --oneline --pretty=format:"%H %s" v0.12.23..v0.12.24
33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release
```
5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
```
5af1e6234ab6da412fb8637393c5a17a1b293663

root@ovpn1:~/devops-netology/terraform# git grep -n 'func providerSource('
provider_source.go:23:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
root@ovpn1:~/devops-netology/terraform#  git log -L:providerSource:provider_source.go --reverse -1                                     
commit 5af1e6234ab6da412fb8637393c5a17a1b293663
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Tue Apr 21 16:28:59 2020 -0700
..

```
6. Найдите все коммиты в которых была изменена функция globalPluginDirs.
```
root@ovpn1:~/devops-netology/terraform# git grep -p 'globalPluginDirs'
commands.go=func initCommands(
commands.go:            GlobalPluginDirs: globalPluginDirs(),
commands.go=func credentialsSource(config *cliconfig.Config) (auth.CredentialsSource, error) {
commands.go:    helperPlugins := pluginDiscovery.FindPlugins("credentials", globalPluginDirs())
internal/command/cliconfig/config_unix.go=func homeDir() (string, error) {
internal/command/cliconfig/config_unix.go:              // FIXME: homeDir gets called from globalPluginDirs during init, before
plugins.go=import (
plugins.go:// globalPluginDirs returns directories that should be searched for
plugins.go:func globalPluginDirs() []string {

root@ovpn1:~/devops-netology/terraform#  git log -L:providerSource:provider_source.go --reverse -1                                     
commit 5af1e6234ab6da412fb8637393c5a17a1b293663
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Tue Apr 21 16:28:59 2020 -0700
...
78b122055 Remove config.go and update things using its aliases
...
52dbf9483 keep .terraform.d/plugins for discovery
...
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
...
66ebff90c move some more plugin search path logic to command
...
8364383c3 Push plugin discovery down into command package
...
```
7. Кто автор функции synchronizedWriters?
```
Martin Atkins

root@ovpn1:~/devops-netology/terraform# git grep -p synchronizedWriters $(git log --pretty=format:"%H" -S "synchronizedWriters")
fd4f7eb0b935e5a838810564fd549afe710ae19a:synchronized_writers.go=type synchronizedWriter struct {
fd4f7eb0b935e5a838810564fd549afe710ae19a:synchronized_writers.go:// synchronizedWriters takes a set of writers and returns wrappers that ensure
fd4f7eb0b935e5a838810564fd549afe710ae19a:synchronized_writers.go:func synchronizedWriters(targets ...io.Writer) []io.Writer {
5ac311e2a91e381e2f52234668b49ba670aa0fe5:main.go=func copyOutput(r io.Reader, doneCh chan<- struct{}) {
5ac311e2a91e381e2f52234668b49ba670aa0fe5:main.go:               wrapped := synchronizedWriters(stdout, stderr)
5ac311e2a91e381e2f52234668b49ba670aa0fe5:synchronized_writers.go=type synchronizedWriter struct {
5ac311e2a91e381e2f52234668b49ba670aa0fe5:synchronized_writers.go:// synchronizedWriters takes a set of writers and returns wrappers that ensure
5ac311e2a91e381e2f52234668b49ba670aa0fe5:synchronized_writers.go:func synchronizedWriters(targets ...io.Writer) []io.Writer {
root@ovpn1:~/devops-netology/terraform# git show --no-patch --pretty=format:"%an" 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Martin Atkins
```
