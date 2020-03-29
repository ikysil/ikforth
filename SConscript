# ikforth

Import('env', 'fkernelPath', 'linconPath')
senv = env.Clone()

ikforthExec = senv.execname('IKForth-${TSYS}');
ikforthDict = 'IKForth-${TSYS}.img'

senv.Replace(RUN_CMD = '${RUN_LAUNCHER} ./' + ikforthExec)

def run(source, target, env):
    env.Execute('${RUN_CMD}')

def test(source, target, env):
    env.Execute('${RUN_CMD} \'S\" IKForth-test.4th\" INCLUDED\'')

def test_stdin(source, target, env):
    env.Execute('echo \'S\" fine!\" TYPE\' | ${RUN_CMD} \'S\" test/stdin-test.4th\" INCLUDED\'')

def ansitest(source, target, env):
    env.Execute('${RUN_CMD} \'S\" test/forth2012-test.4th\" INCLUDED\'')

def fptest(source, target, env):
    env.Execute('${RUN_CMD} \'S\" test/fp-test.4th\" INCLUDED\'')

source_dir = '#build/ikforth-dev-$TSYS-$TERMINIT/'
ikforthSrcDict = source_dir + 'ikforth-dev-x86.img'

senv.Command(ikforthDict, ikforthSrcDict, Copy('$TARGET', '$SOURCE'))
senv.Command(ikforthExec, fkernelPath, Copy('$TARGET', '$SOURCE'))

senv.Alias('ikforth', ['lincon', ikforthExec, ikforthDict])

senv.Alias('all', 'ikforth')
senv.Depends('all', [ikforthSrcDict])
senv.Clean('all', ['#build', '#IKForth-*.elf', '#IKForth-*.img', '#IKForth-*.exe'])

senv.Alias('run', [], run)
senv.Alias('test', [], test)
senv.Alias('test-stdin', [], test_stdin)
senv.Alias('ansitest', [], ansitest)
senv.Alias('fptest', [], fptest)

senv.Depends('run',        ['all'])
senv.Depends('test',       ['all'])
senv.Depends('test-stdin', ['all'])
senv.Depends('ansitest',   ['all'])
senv.Depends('fptest',     ['all'])

senv.AlwaysBuild('run', 'test', 'test-stdin', 'ansitest', 'fptest')
