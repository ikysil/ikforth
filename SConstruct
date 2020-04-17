import os

env = Environment(ENV = os.environ)

env.SConscriptChdir(0)
env.SConscript('SConstruct-config',
        exports = ['env'])

fkernelPath = env.SConscript(dirs = ['tools/loader'],
        exports = ['env'],
        variant_dir = 'build/loader-$TSYS', duplicate = 0)

env_bootdict = env.Clone()
env_bootdict['ARCH'] = 'x86'
bootdict = env.SConscript(dirs = ['bootdict'],
        exports = ['env_bootdict'],
        variant_dir = 'build/bootdict', duplicate = 0)

env.SConscript(dirs = ['tools/winconst-extract'],
        exports = ['env'],
        variant_dir = 'build/winconst-extract', duplicate = 1)

env.SConscript(dirs = ['tools/linconst-extract'],
        exports = ['env'],
        variant_dir = 'build/linconst-extract', duplicate = 1)

productdict = env.SConscript(dirs = ['product/ikforth-dev-x86'],
        exports = ['env', 'fkernelPath', 'bootdict'],
        variant_dir = 'build/ikforth-dev-$TSYS-$TERMINIT', duplicate = 1)

env.SConscript('SConscript',
        exports = ['env', 'fkernelPath', 'productdict'])

env.Default('all')
