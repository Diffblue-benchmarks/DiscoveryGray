@echo on
@echo =============================================================
@echo $                                                           $
@echo $                     Nepxion Discovery                     $
@echo $                                                           $
@echo $                                                           $
@echo $                                                           $
@echo $  Nepxion Studio All Right Reserved                        $
@echo $  Copyright (C) 2017-2050                                  $
@echo $                                                           $
@echo =============================================================
@echo.
@echo off

@title Nepxion Discovery Gay [Zuul]
@color 0a

@set PROJECT_NAME=discovery-gray-zuul

@set DOCKER_HOST=tcp://localhost:2375
@rem @set DOCKER_CERT_PATH=C:\Users\Neptune\.docker\machine\certs
@set IMAGE_NAME=gray-zuul
@set MAIN_CLASS=com.nepxion.discovery.gray.zuul.DiscoveryGrayZuul
@set MACHINE_PORT=5002
@set CONTAINER_PORT=5002
@set RUN_MODE=-i -t
@rem @set RUN_MODE=-d

if exist %PROJECT_NAME%\target rmdir /s/q %PROJECT_NAME%\target

@rem 执行相关模块的Maven Install
call mvn clean install -DskipTests -pl %PROJECT_NAME% -am -DMainClass=%MAIN_CLASS%

@rem 停止和删除Docker容器
call docker stop %IMAGE_NAME%
@rem call docker kill %IMAGE_NAME%
call docker rm %IMAGE_NAME%

@rem 删除Docker镜像
call docker rmi %IMAGE_NAME%

cd %PROJECT_NAME%

@rem 安装Docker镜像
call mvn package docker:build -DskipTests -DImageName=%IMAGE_NAME% -DExposePort=%CONTAINER_PORT%

@rem 安装和启动Docker容器，并自动执行端口映射
call docker run %RUN_MODE% -p %MACHINE_PORT%:%CONTAINER_PORT% -h %IMAGE_NAME% --name %IMAGE_NAME% %IMAGE_NAME%:latest

pause