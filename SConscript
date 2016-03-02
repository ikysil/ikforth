# ikforth

Import('env')
senv = env.Clone()
senv.Replace(RUN_CMD = '${RUN_LAUNCHER} IKForth.exe')

def run(source, target, env):
    env.Execute('${RUN_CMD}')

def test(source, target, env):
    env.Execute('${RUN_CMD} \'S\" IKForth-test.4th\" INCLUDED\'')

def test_stdin(source, target, env):
    env.Execute('echo \'S\" fine!\" TYPE\' | ${RUN_CMD} \'S\" test/stdin-test.4th\" INCLUDED\'')

if 'term' in BUILD_TARGETS:
    source_dir = '#build/ikforth-ansiterm'
else:
    source_dir = '#build/ikforth-winconsole'

senv.Command('IKForth.img', source_dir + '/IKForth.img', Copy('$TARGET', '$SOURCE'))
senv.Command('IKForth.exe', '#build/loader/FKernel.exe', Copy('$TARGET', '$SOURCE'))

senv.Alias('ikforth', ['IKForth.img', 'IKForth.exe'])

senv.Alias('run', [], run)
senv.Alias('test', [], test)
senv.Alias('test-stdin', [], test_stdin)

senv.Depends('run',        ['ikforth'])
senv.Depends('test',       ['ikforth'])
senv.Depends('test-stdin', ['ikforth'])

senv.AlwaysBuild('run', 'test', 'test-stdin')
