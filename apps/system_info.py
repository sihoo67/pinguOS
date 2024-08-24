# system_info.py
import os
import platform

def system_info():
    print("Operating System:", platform.system())
    print("OS Version:", platform.version())
    print("Machine:", platform.machine())
    print("Processor:", platform.processor())

if __name__ == "__main__":
    system_info()
