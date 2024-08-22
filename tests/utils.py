import time


def wait_for_text(
    pane, search_string, timeout=15, verbose=False, interval=1, wiggle_char=None
):
    for frame in range(timeout):
        screen = "\n".join(pane.cmd("capture-pane", "-p").stdout)
        if verbose:
            print("- " * 100, frame)
            print(screen)
        if search_string in screen:
            return True
        elif wiggle_char:
            # Backspace and retype the last character to trigger autocomplete.
            if frame % 2 == 0:
                pane.send_keys("\x7F", enter=False)
            else:
                pane.send_keys(wiggle_char, enter=False)

        time.sleep(interval)

    return False
