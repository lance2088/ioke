/*
 * See LICENSE file in distribution for copyright and licensing information.
 */
package ioke.lang;

import java.util.Arrays;
import java.util.List;

import ioke.lang.exceptions.ControlFlow;
import ioke.lang.exceptions.MismatchedArgumentCount;

/**
 *
 * @author <a href="mailto:ola.bini@gmail.com">Ola Bini</a>
 */
public class LexicalBlock extends IokeData {
    private List<String> argumentNames;
    private IokeObject context;
    private IokeObject message;

    public LexicalBlock(IokeObject context, List<String> argumentNames, IokeObject message) {
        this.context = context;
        this.argumentNames = argumentNames;
        this.message = message;
    }

    public LexicalBlock(IokeObject context) {
        this(context, Arrays.<String>asList(), context.runtime.nilMessage);
    }

    @Override
    public void init(IokeObject lexicalBlock) {
        lexicalBlock.setKind("LexicalBlock");

        lexicalBlock.registerMethod(lexicalBlock.runtime.newJavaMethod("invokes the block with the arguments provided, returning the result of the last expression in the block", new JavaMethod("call") {
                @Override
                public Object activate(IokeObject self, IokeObject dynamicContext, IokeObject message, Object on) throws ControlFlow {
                    return IokeObject.as(on).activate(dynamicContext, message, on);
                }
            }));
    }

    @Override
    public Object activate(IokeObject self, IokeObject dynamicContext, IokeObject message, Object on) throws ControlFlow {
        int argCount = message.getArguments().size();

        if(argCount != argumentNames.size()) {
            throw new MismatchedArgumentCount(message, argumentNames.size(), argCount, on, context);
        }

        LexicalContext c = new LexicalContext(self.runtime, on, "Lexical activation context", message, this.context);
        for(int i=0; i<argCount; i++) {
            c.setCell(argumentNames.get(i), message.getEvaluatedArgument(i, dynamicContext));
        }

        return this.message.evaluateCompleteWith(c, on);
    }
}// LexicalBlock
