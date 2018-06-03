package aes.framework.errors 
{
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesArgumentError extends ArgumentError 
	{
		
		public function AesArgumentError(arg:String, error:String = 'равен null', id:* = 0) 
		{
			super('Аргумент ' + arg + ' не должен быть ' + error, id);
		}
		
	}
}