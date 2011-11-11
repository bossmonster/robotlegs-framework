//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.core.api.ILogger;
	import org.robotlegs.v2.core.api.ILogTarget;
	import org.robotlegs.v2.core.impl.support.CallbackLogTarget;

	public class LoggerTests
	{

		[Before]
		public function setUp():void
		{
		}

		[After]
		public function tearDown():void
		{
		}

		[Test]
		public function name_is_logged():void
		{
			const name:String = 'Logger1';
			const info:LogInfo = new LogInfo();
			const logger:ILogger = createReportingLogger(info, name);
			logger.debug('any');
			assertThat(info.name, equalTo(name));
		}

		[Test]
		public function message_is_logged():void
		{
			const message:String = 'hello';
			const info:LogInfo = new LogInfo();
			const logger:ILogger = createReportingLogger(info);
			logger.debug(message);
			assertThat(info.message, equalTo(message));
		}

		[Test]
		public function parameters_are_logged():void
		{
			const parameters:Array = [0, 1];
			const info:LogInfo = new LogInfo();
			const logger:ILogger = createReportingLogger(info);
			logger.debug('', parameters);
			assertThat(info.parameters, equalTo(parameters));
		}

		[Test]
		public function logging_ignored_when_level_is_zero():void
		{
			const info:LogInfo = new LogInfo();
			const logger:ILogger = createReportingLogger(info, 'test', 0);
			logger.debug('');
			logger.info('');
			logger.warn('');
			logger.error('');
			logger.fatal('');
			assertThat(info.timesCalled, equalTo(0));
		}

		[Test]
		public function fatal_logged_when_level_allows():void
		{
			const info:LogInfo = new LogInfo();
			const logger:ILogger = createReportingLogger(info, 'test', 2);
			logger.debug('');
			logger.info('');
			logger.warn('');
			logger.error('');
			logger.fatal('');
			assertThat(info.timesCalled, equalTo(1));
		}

		[Test]
		public function logger_does_not_throw_error_for_null_target():void
		{
			const logger:ILogger = new Logger('test');
			logger.debug('');
			logger.info('');
			logger.warn('');
			logger.error('');
			logger.fatal('');
		}

		private function createReportingLogger(info:LogInfo, name:String = 'test', level:uint = 32):ILogger
		{
			const target:ILogTarget = createReportingTarget(info, level);
			return new Logger(name, target);
		}

		private function createReportingTarget(info:LogInfo, level:uint = 32):ILogTarget
		{
			return new CallbackLogTarget(
				level,
				function(name:String, level:int, time:Number, message:*, parameters:Array = null):void
				{
					info.timesCalled++;
					info.name = name;
					info.level = level;
					info.time = time;
					info.message = message;
					info.parameters = parameters;
				});
		}
	}
}

class LogInfo
{
	public var timesCalled:uint;

	public var name:String;

	public var level:uint;

	public var time:Number;

	public var message:*;

	public var parameters:Array;
}