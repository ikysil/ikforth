import os

env = Environment(ENV = os.environ)

env.SConscriptChdir(0)
env.SConscript('SConstruct-config',
        exports = ['env'])

env = env.Clone(LSYS = 'nt')
env.SConscript(dirs = ['src/loader'],
        exports = ['env'],
        variant_dir = 'build/loader-nt', duplicate = 0)

env = env.Clone(LSYS = 'linux')
env.SConscript(dirs = ['src/loader'],
        exports = ['env'],
        variant_dir = 'build/loader-linux', duplicate = 0)

env.SConscript(dirs = ['src/image'],
        exports = ['env'],
        variant_dir = 'build/image', duplicate = 0)

env = env.Clone(TERMINIT = 'ANSITERM-INIT')
env.SConscript(dirs = ['src/kernel.0'],
        exports = ['env'],
        variant_dir = 'build/ikforth-ansiterm', duplicate = 1)

env = env.Clone(TERMINIT = 'WINCONSOLE-INIT')
env.SConscript(dirs = ['src/kernel.0'],
        exports = ['env'],
        variant_dir = 'build/ikforth-winconsole', duplicate = 1)

env.SConscript('SConscript',
        exports = ['env'])

env.Default('all')
