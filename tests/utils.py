import time


def wait_for_text(pane, search_string, timeout=60, verbose=False, interval=1):
    for frame in range(timeout):
        screen = "\n".join(pane.cmd("capture-pane", "-p").stdout)
        if verbose:
            print("- " * 100, frame)
            print(screen)
        if search_string in screen:
            return True

        time.sleep(interval)

    return False


def wait_for_change(pane, command, timeout=60, verbose=False, interval=1):
    pane.send_keys(command)
    old_screen = "\n".join(pane.cmd("capture-pane", "-p").stdout)
    for frame in range(timeout):
        screen = "\n".join(pane.cmd("capture-pane", "-p").stdout)
        if verbose:
            print("- " * 100, frame)
            print(screen)
        if screen != old_screen:
            return True

        time.sleep(interval)

    return False
