# ikforth

Import('env')
senv = env.Clone()
senv.Replace(RUN_CMD = 'IKFORTHTERMINIT=${TERMINIT} ${RUN_LAUNCHER} IKForth.exe')

def run(source, target, env):
    env.Execute('${RUN_CMD}')

def test(source, target, env):
    env.Execute('${RUN_CMD} \'S\" IKForth-test.4th\" INCLUDED\'')

def test_stdin(source, target, env):
    env.Execute('echo \'S\" fine!\" TYPE\' | ${RUN_CMD} \'S\" test/stdin-test.4th\" INCLUDED\'')

senv.Command('IKForth.img', 'build/kernel.0/IKForth.img', Copy('$TARGET', '$SOURCE'))
senv.Command('IKForth.exe', 'build/kernel.0/FKernel.exe', Copy('$TARGET', '$SOURCE'))

senv.Alias('ikforth', ['IKForth.img', 'IKForth.exe'])

senv.Alias('run', [], run)
senv.Alias('test', [], test)
senv.Alias('test-stdin', [], test_stdin)

senv.Depends('run',        ['ikforth'])
senv.Depends('test',       ['ikforth'])
senv.Depends('test-stdin', ['ikforth'])

senv.AlwaysBuild('run', 'test', 'test-stdin')
