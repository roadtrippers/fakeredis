module FakeRedis
  module CommandExecutor
    def clean_reply(reply)
      if reply == true
        1
      elsif reply == false
        0
      else
        reply
      end
    end

    def write(command)
      meffod = command.shift.to_s.downcase.to_sym

      if in_multi && !(TRANSACTION_COMMANDS.include? meffod) # queue commands
        queued_commands << [meffod, *command]
        reply = 'QUEUED'
      elsif respond_to?(meffod)
        reply = send(meffod, *command)
      else
        raise Redis::CommandError, "ERR unknown command '#{meffod}'"
      end

      reply = clean_reply(reply)

      replies << reply
      nil
    end
  end
end
