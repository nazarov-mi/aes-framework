package aes.framework.errors
{
	/**
	 * @author Назаров М.И.
	 */
	
	public final class AesAbstractClassError extends Error
	{
		
		public function AesAbstractClassError()
		{
			super('Попытка создать экземпляр абстрактного класса');
			
		}
		
	}
}