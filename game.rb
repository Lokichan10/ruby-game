require 'curses'
include Curses

# Инициализация окна
init_screen
cbreak
noecho
curs_set(0)
stdscr.keypad(true)
timeout = 100

# Настройка цветов
start_color
init_pair(1, COLOR_GREEN, COLOR_BLACK)  # змейка
init_pair(2, COLOR_RED, COLOR_BLACK)    # еда

# Начальные параметры
snake = [[10,10],[10,9],[10,8]]
direction = :right
food = [rand(1..20), rand(1..50)]
score = 0

begin
  loop do
    clear

    # Отрисовка еды
    attron(color_pair(2)) { setpos(food[0], food[1]); addstr("■") }

    # Отрисовка змейки
    attron(color_pair(1)) do
      snake.each { |y,x| setpos(y,x); addstr("O") }
    end

    # Отрисовка счета
    setpos(0,0)
    addstr("Score: #{score}")

    refresh

    # Чтение ввода
    case stdscr.getch
    when KEY_UP    then direction = :up unless direction == :down
    when KEY_DOWN  then direction = :down unless direction == :up
    when KEY_LEFT  then direction = :left unless direction == :right
    when KEY_RIGHT then direction = :right unless direction == :left
    end

    # Движение змейки
    head = snake.first.dup
    case direction
    when :up    then head[0] -= 1
    when :down  then head[0] += 1
    when :left  then head[1] -= 1
    when :right then head[1] += 1
    end
    snake.unshift(head)

    # Проверка еды
    if head == food
      score += 1
      food = [rand(1..20), rand(1..50)]
    else
      snake.pop
    end

    # Проверка столкновений
    break if head[0] <= 0 || head[0] >= lines-1 || head[1] <= 0 || head[1] >= cols-1
    break if snake[1..-1].include?(head)

    sleep(0.1)
  end

ensure
  close_screen
  puts "Game Over! Ваш счет: #{score}"
end
