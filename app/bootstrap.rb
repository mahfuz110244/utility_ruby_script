require 'colorize'
require	'readline'
require_relative 'color_info'
require_relative 'file_encrypt'
require_relative 'file_decrypt'
require_relative 'utility'

#	Prevent	Ctrl+C	for	exiting
trap('INT',	'SIG_IGN')

class Bootstrap
  #
  # 	List	of	commands
  #

  NAME = 'ASSISTANT'
  CMDS	=	%w[	help encryption ls exit decryption t_login].sort
  include Utility

  #
  # attributes
  #
  attr_accessor :encryption_key

  #
  # instance methods
  #

  def run_command
    completion	=
        proc	do	|str|
          case
            when	Readline.line_buffer	=~	/help.*/i
              puts	"Available	commands:\n"	+	"#{CMDS.join("\t")}"
            when	Readline.line_buffer	=~	/ls.*/i
              puts	`ls`
            when Readline.line_buffer =~ /encryption/
              FileEncrypt.new.run
            when Readline.line_buffer =~ /decryption/
              FileDecrypt.new.run
            when	Readline.line_buffer	=~	/exit.*/i
              exit_msg
              exit	0
            else
              CMDS.grep(	/^#{Regexp.escape(str)}/i	)	unless	str.nil?
          end
        end

    #	Set	completion	process
    Readline.completion_proc	=	completion

    #	Make	sure	to	add	a	space	after	completion
    Readline.completion_append_character	=	'	'

    while	line	=	Readline.readline('new task -> '.c_instruction,	true)
      puts	completion.call
      break	if	line	=~	/^quit.*/i	or	line	=~	/^exit.*/i
    end
  end
end

Bootstrap.new.run_command