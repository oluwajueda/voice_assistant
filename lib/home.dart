import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voiceai/colors.dart';
import 'package:voiceai/feature_box.dart';
import 'package:voiceai/openai_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  String lastwords = "";
  final OpenAIService openAIService = OpenAIService();
  final flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initSpeechToText();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastwords = result.recognizedWords;
    });
  }

  String? generatedContent;
  String? generateImageUrl;

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IAnswer"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/virtualAssistant.png"))),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius:
                    BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  generatedContent == null
                      ? "Good morning, what can I do for you?"
                      : generatedContent!,
                  style: TextStyle(
                    fontFamily: "Cera Pro",
                    color: Pallete.mainFontColor,
                    fontSize: generatedContent == null ? 25 : 18,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, left: 22),
              child: const Text(
                "Here are a few features",
                style: TextStyle(
                    fontFamily: "Cera Pro",
                    color: Pallete.mainFontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: [
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: "ChatGPT",
                  description:
                      "A smarter way to stay organized and informed with ChatGPT",
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: "Dall-E",
                  description:
                      "Get inspired and stay creative with your personal assistant powered by Dall-E",
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: "Smart Voice Assistance",
                  description:
                      "Get the best of both worlds with a voice assistance powered by Dall-E and chatGPT",
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastwords);
            if (speech.contains("https")) {
              generateImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generateImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
            }

            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic),
      ),
    );
  }
}
