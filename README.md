# Пример CRM на Ruby on Rails

[![Coverage Status](https://coveralls.io/repos/github/badimalex/admin-task/badge.svg?branch=master)](https://coveralls.io/github/badimalex/admin-task?branch=master)
[![Build Status](https://travis-ci.org/badimalex/admin-task.svg?branch=master)](https://travis-ci.org/badimalex/admin-task)

  - В системе реализована кастомная аутентификация
  - Пользователи могут регистрироваться на проекте, логиниться и делать «выход из проекта».
  - Существуют три роли: зарегистрированный пользователь, администратор и гость.
  - Для разделения доступа был использован гем 'cancan'
  - Зарегистрированные пользователи могут создавать, редактировать, удалять свои задачи.
  - Реализована функция прикрепления файлов к задаче, с помощью гема 'carrierwave'
  - Администратор может назначать задачи, а также редактировать, удалять задачи любых пользователей.
  - Гости могут только просматривать задачи.
  - На главной странице выводится список всех задач в системе
  - Для смены статуса задачи использован гем 'state_machines-activerecord'
  - В качестве шаблонизатора использован 'slim', для верстки "Twitter Bootstrap 3"
  - Для оценки кодового покрытия использован гем 'simplecov'

### Установка

  - пример конфигурации бд (config/database.yml.sample)

```sh
$ bundle install
$ rake db:create
$ rake db:migrate
$ rails server
```

  - для создания пользователей с ролями (admin, user)

```sh
$ rake db:seed
```
  - Это даст  пользователей с ролями [admin, user]@example.com соответственно. Пароль 123456

Для наполнения БД фейковыми данными

```sh
$ rake db:populate
```

### Запуск тестов

```sh
$ rspec spec/
```
