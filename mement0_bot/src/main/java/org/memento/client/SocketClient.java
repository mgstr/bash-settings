package org.memento.client;

import com.google.common.base.Strings;
import org.apache.commons.io.IOUtils;
import org.memento.BotConfig;
import org.telegram.telegrambots.logging.BotLogger;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

/**
 * Created by Vitalii_Chistiakov on 4/20/2017.
 */
public class SocketClient {
    private static final String LOGTAG = "SOCKETCLIENT";

    public String send(String request) {
        String port = System.getenv("SERVER_PORT");
        if (Strings.isNullOrEmpty(port)) {
            throw new RuntimeException("SERVER_PORT environment variable not set but required");
        }
        try (
                Socket socket = new Socket(BotConfig.SERVER_HOST, Integer.valueOf(port));
                PrintWriter out = new PrintWriter(socket.getOutputStream());
                InputStream in = socket.getInputStream()
        ) {
            out.write(request);
            return IOUtils.toString(in, StandardCharsets.UTF_8);
        } catch (IOException e) {
            BotLogger.error(LOGTAG, e);
            return null;
        }
    }

}
