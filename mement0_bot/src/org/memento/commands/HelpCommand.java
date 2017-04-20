package org.memento.commands;

import org.telegram.telegrambots.api.methods.send.SendMessage;
import org.telegram.telegrambots.api.objects.Chat;
import org.telegram.telegrambots.api.objects.User;
import org.telegram.telegrambots.bots.AbsSender;
import org.telegram.telegrambots.bots.commands.BotCommand;
import org.telegram.telegrambots.bots.commands.ICommandRegistry;
import org.telegram.telegrambots.exceptions.TelegramApiException;
import org.telegram.telegrambots.logging.BotLogger;

/**
 * This command helps the user to find the command they need
 *
 * @author Timo Schulz (Mit0x2)
 */
public class HelpCommand extends BotCommand {

    private static final String LOGTAG = "HELPCOMMAND";

    private final ICommandRegistry commandRegistry;

    public HelpCommand(ICommandRegistry commandRegistry) {
        super("help", "Get all the commands this bot provides");
        this.commandRegistry = commandRegistry;
    }

    @Override
    public void execute(AbsSender absSender, User user, Chat chat, String[] strings) {

        StringBuilder helpMessageBuilder = new StringBuilder("<b>Help</b>\n");
        helpMessageBuilder.append("These are the registered commands for this Bot:\n/s <filters>, where\n" +
                "filter:\n" +
                "   text - search text anywhere (part of the word are OK)\n" +
                "  +text - search text as word\n" +
                "to show all onelines use '--all' option.\n\n" +
                "results are highlighted using VT100 coloring codes:\n" +
                "  text that match filter is highlighted by ${RED}red${EOC}\n" +
                "  info is highlightd by ${GREEN}green${EOC}\n" +
                "On linux terminal will interprete them, on Windows you need colorize.exe (Windows 10 only) to display colors.\n" +
                "information is stored in the .memento file(s) in the tab separated format:\n" +
                "  <info>\\\\t<description>\\\\t<tags>, where\n" +
                "  info - shortcut key, url, configuration, command line options, sample etc\n" +
                "  description - text that explains info\n" +
                "  tags - text that used in filtering, but not shown in the CLI output\n" +
                "Exmaples:\n" +
                "  memento terminal +shortcut\n" +
                "    find all keyboard shortcuts for 'terminal' program\n" +
                "  memento http\n" +
                "    find all info containing URLs\n" +
                "  memento tab\n" +
                "    find info containing tab anywhere in the text (tabs will be matched as well)\n" +
                "  memento +tab\n" +
                "    find info containing \"tab\" word");

        for (BotCommand botCommand : commandRegistry.getRegisteredCommands()) {
            helpMessageBuilder.append(botCommand.toString()).append("\n\n");
        }

        SendMessage helpMessage = new SendMessage();
        helpMessage.setChatId(chat.getId().toString());
        helpMessage.enableHtml(true);
        helpMessage.setText(helpMessageBuilder.toString());

        try {
            absSender.sendMessage(helpMessage);
        } catch (TelegramApiException e) {
            BotLogger.error(LOGTAG, e);
        }
    }
}
