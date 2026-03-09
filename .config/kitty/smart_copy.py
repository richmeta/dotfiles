"""
support sending super+c to nvim if in nvim
"""

from kittens.tui.handler import result_handler

def main(args):
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    # Get the window object using the ID
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    # Get the foreground process of the active window
    fp = window.child.foreground_processes
    
    # Check if 'nvim' is in the command line of any foreground process
    is_nvim = any('nvim' in p['cmdline'][0] for p in fp)

    if is_nvim:
        # Send the CSI u sequence for <D-c> directly to the child process
        # \x1b is Escape; [99 is 'c'; 5 is the Super modifier; u is the protocol suffix
        window.write_to_child('\x1b[99;5u')
    else:
        # Fall back to Kitty's internal clipboard copy
        window.copy_to_clipboard()
