import os

env = Environment(ENV = os.environ)

env.SConscriptChdir(0)
env.SConscript('SConstruct-config',
        exports = ['env'])

fkernelPath = env.SConscript(dirs = ['src/loader'],
        exports = ['env'],
        variant_dir = 'build/loader-$TSYS', duplicate = 0)

env.SConscript(dirs = ['src/lincon'],
        exports = ['env'],
        variant_dir = 'build/lincon', duplicate = 0)

env.SConscript(dirs = ['src/image'],
        exports = ['env'],
        variant_dir = 'build/image', duplicate = 0)

env.SConscript(dirs = ['src/kernel.0'],
        exports = ['env', 'fkernelPath'],
        variant_dir = 'build/ikforth-$TERMINIT', duplicate = 1)

env.SConscript('SConscript',
        exports = ['env', 'fkernelPath'])

env.Default('all')
