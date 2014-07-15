require "seqtk_bindings"
require "bio/kseq/version"

module Bio
  module SeqTK
    class Kseq
      def to_s
        if qual.nil?
          if comment.nil?
            ">" + name + "\n" + seq
          else
            ">" + name + " " + comment + "\n" + seq
          end
        else
          if comment.nil?
            "@" + name + "\n" + seq + "\n+\n" + qual
          else
            "@" + name + " " + comment + "\n" + seq + "\n+\n" + qual
          end
        end
      end
    end
  end
end
