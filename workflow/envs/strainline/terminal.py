import curses, traceback

def main(stdscr):
    stdscr.refresh()
    stdscr.getch()


if __name__=='__main__':
    curses.wrapper(main)
    # traceback.print_exc()           # Print the exception