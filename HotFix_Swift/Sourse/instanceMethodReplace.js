// 替换崩溃方法
fixMethod('HFTestClass', 'instanceReplaceWithString:', 1,
          function() {
                runMethod("HFTestClass","replaceLogWithString:");
          });
