class Popen3
  attr_reader :pid
  attr_reader :fromchild
  attr_reader :tochild
  attr_reader :childerr


  def initialize *command
    @command = command
    @parent_pipe, @child_pipe = init_pipe
    @tochild, @fromchild, @childerr = @parent_pipe[ :tochild ], @parent_pipe[ :fromchild ], @parent_pipe[ :childerr ]
  end


  def wait
    Process.wait @pid
  end


  def popen3
    # Child process
    @pid = Kernel.fork do
      close_end_of @parent_pipe

      STDIN.reopen @child_pipe[ :stdin ]
      STDOUT.reopen @child_pipe[ :stdout ]
      STDERR.reopen @child_pipe[ :stderr ]

      close_end_of @child_pipe

      Kernel.exec *@command
    end

    # Parent
    close_end_of @child_pipe
    @parent_pipe[ :tochild ].sync = true

    if block_given?
      begin
        return yield( @parent_pipe[ :tochild ], @parent_pipe[ :fromchild ], @parent_pipe[ :childerr ] )
      ensure
        close_end_of @parent_pipe
      end
    end
    return [ @parent_pipe[ :tochild ], @parent_pipe[ :fromchild ], @parent_pipe[ :childerr ] ]
  end


  private


  def close_end_of pipe
    pipe.each do | name, pipe |
      unless pipe.closed?
        pipe.close
      end
    end
  end


  def init_pipe
    child_stdin, tochild = IO.pipe
    fromchild, child_stdout = IO.pipe
    childerr, child_stderr = IO.pipe

    return [ { :tochild => tochild, :fromchild => fromchild, :childerr => childerr },
             { :stdin => child_stdin, :stdout => child_stdout, :stderr => child_stderr } ]
  end
end


module Kernel
  def popen3 *command, &block
    return Popen3.new( *command ).popen3( &block )
  end
  module_function :popen3
end
