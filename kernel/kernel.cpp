// kernel.cpp
extern "C" void kernel_main() {
    char* video_memory = (char*) 0xb8000;
    const char* message = "Welcome to Pingu OS 64-bit!";

    for (int i = 0; message[i] != '\0'; i++) {
        video_memory[i * 2] = message[i];
        video_memory[i * 2 + 1] = 0x07;
    }

    while (1) {
        __asm__("hlt");
    }
}
