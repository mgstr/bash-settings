package org.memento.client;

import com.google.common.base.Strings;
import org.apache.commons.codec.binary.StringUtils;
import org.memento.BotConfig;
import org.telegram.telegrambots.logging.BotLogger;

import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

/**
 * Created by Vitalii_Chistiakov on 4/20/2017.
 */
public class SocketClient {
    private static final String LOGTAG = "SOCKETCLIENT";

    public String send(String request) {
        String response = null;

        String port = System.getenv("SERVER_PORT");
        if (Strings.isNullOrEmpty(port)) {
            throw new RuntimeException("SERVER_PORT environment variable not set but required");
        }
        try (
                Socket socket = new Socket(BotConfig.SERVER_HOST, Integer.valueOf(port));
                ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream());
                InputStream in = socket.getInputStream()
        ) {
            out.writeObject(request);
            try (
                    ObjectInputStream ois =
                            new ObjectInputStream(in)) {
                try {
                    response = (String) ois.readObject();
                } catch (ClassNotFoundException e) {
                    BotLogger.error("Exception occured while reading response", LOGTAG, e);
                }
            }
            return response;
        } catch (IOException e) {
            BotLogger.error(LOGTAG, e);
            return null;
        }
    }

}
