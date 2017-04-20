package org.memento.commands;

import org.telegram.telegrambots.api.methods.send.SendMessage;
import org.telegram.telegrambots.api.objects.Chat;
import org.telegram.telegrambots.api.objects.User;
import org.telegram.telegrambots.bots.AbsSender;
import org.telegram.telegrambots.bots.commands.BotCommand;
import org.telegram.telegrambots.exceptions.TelegramApiException;
import org.telegram.telegrambots.logging.BotLogger;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Created by Vitalii_Chistiakov on 4/20/2017.
 */
public class SearchCommand extends BotCommand {

    private static final String LOGTAG = "SEARCHCOMMAND";

    public SearchCommand() {
        super("s", "search");
    }

    @Override
    public void execute(AbsSender absSender, User user, Chat chat, String[] arguments) {
        StringBuilder filters = new StringBuilder();
        if (arguments != null && arguments.length > 0) {
            filters.append(String.join(" ", arguments));
        }
        String searchResult = processSearch(filters.toString());
        if (searchResult == null) return;
        SendMessage answer = new SendMessage();
        answer.setChatId(chat.getId().toString());
        answer.setText(searchResult);

        try {
            absSender.sendMessage(answer);
        } catch (TelegramApiException e) {
            BotLogger.error(LOGTAG, e);
        }
    }

    public static String processSearch(String arguments) {
        Process process;
        String searchResult;
        try {
            process = Runtime.getRuntime().exec("@perl memento.pl "  + arguments + " | colorize");
            if (process.waitFor() != 0) {
                BotLogger.error(LOGTAG, "memento.pl exit code is non-zero");
            }
            searchResult = extractOutput(process);
        } catch (IOException | InterruptedException e) {
            BotLogger.error(LOGTAG, e);
            return null;
        }
        return searchResult;
    }

    private static String extractOutput(Process process) throws IOException {
        StringBuffer sb = new StringBuffer();
        BufferedReader br = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line).append("\n");
        }
        return sb.toString();
    }
}
