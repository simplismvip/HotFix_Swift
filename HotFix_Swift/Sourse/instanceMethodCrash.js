// 修复崩溃方法
fixMethod('HFTestClass', 'instanceMethodCrashWithString:', 1,
          function(instance, originInvocation, originArguments) {
              if (originArguments[0] == null) {
                  runError('HFTestClass', 'instanceMethodCrashWithString:');
              } else {
                  //runError('HFTestClass', 'instanceMethodCrashWithString:');
                  runInvocation('HFTestClass','instanceMethodCrashReplace');
              }
          });
