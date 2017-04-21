package org.memento.client;

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

        try (
                Socket socket = new Socket(BotConfig.SERVER_HOST, BotConfig.SERVER_PORT);
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
