// 修改setter方法，在设置属性的时候修改为新值
fixMethod('HFTestClass', 'setTest:', 2,
          function(instance, originInvocation, originArguments) {
            var params = new Array();
            params[0] = '🤪🤪🤪惊喜不惊喜，原来的🐶🐶🐱🐭🐭🐹变成我了！'
            changeproperty(originInvocation,params);
          });
