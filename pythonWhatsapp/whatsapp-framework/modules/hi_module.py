from app.mac import mac, signals

@signals.message_received.connect
def handle(message):
    #message.log() to see message object properties
    print(message.conversation)
    if message.text == "hi":
        mac.send_message("Hello", message.conversation)
        #mac.send_image("path/to/image.png", message.conversation)
        #mac.send_video("path/to/video.mp4", message.conversation)


@signals.message_received.connect
def handle(message):
    #message.log() to see message object properties
    print(message.conversation)
    if message.text == "start":
        mac.send_message("Please Translate:", message.conversation)
        mac.send_message("die Steckdose", message.conversation)
        #mac.send_image("path/to/image.png", message.conversation)
        #mac.send_video("path/to/video.mp4", message.conversation)
    elif message.text == "plug":
        mac.send_message("Right!!!", message.conversation)
        #mac.send_image("path/to/image.png", message.conversation)
        #mac.send_video("path/to/video.mp4", message.conversation)
    else:
        mac.send_message("Falsch!!!", message.conversation)
        mac.send_message("Try agin", message.conversation)
        mac.send_message("die Steckdose", message.conversation)


