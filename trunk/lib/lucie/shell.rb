require 'lucie/popen3'
require 'English'


class Shell
  attr_writer :child_status


  def open &block
    block.call self
  end


  def on_exit &block
    @on_exit = block
  end


  def on_stdout &block
    @on_stdout = block
  end


  def on_stderr &block
    @on_stderr = block
  end


  def on_success &block
    @on_success = block
  end


  def on_failure &block
    @on_failure = block
  end


  def puts data
    @tochild.puts data
  end


  def exec env, *command
    process = Popen3.new( env, *command )
    process.popen3 do | tochild, fromchild, childerr |
      @tochild, @fromchild, @childerr = tochild, fromchild, childerr

      stdout_thread = Thread.new do
        while line = @fromchild.gets do
          do_stdout line
        end
      end
      stderr_thread = Thread.new do
        while line = @childerr.gets do
          do_stderr line
        end
      end

      stdout_thread.join
      stderr_thread.join
    end

    process.wait
    do_exit

    handle_exitstatus
  end


  private


  def handle_exitstatus
    if child_status.exitstatus == 0
      do_success
    else
      do_failure
    end
  end


  def child_status
    return( @child_status ? @child_status : $CHILD_STATUS )
  end


  def do_stdout line
    if @on_stdout
      @on_stdout.call line
    end
  end


  def do_stderr line
    if @on_stderr
      @on_stderr.call line
    end
  end


  def do_failure
    if @on_failure
      @on_failure.call
    end
  end


  def do_success
    if @on_success
      @on_success.call
    end
  end


  def do_exit
    if @on_exit
      @on_exit.call
    end
  end
end
