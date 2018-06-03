package aes.framework.gfx.assembler 
{
	/**
	 * @author Назаров М.И.
	 */
	
	public class AesOperations 
	{
		
		public static const MOV:AesOperation = new AesOperation(0x00, AesOperationFlag.NO_SOURCE2);
		public static const ADD:AesOperation = new AesOperation(0x01, 0);
		public static const SUB:AesOperation = new AesOperation(0x02, 0);
		public static const MUL:AesOperation = new AesOperation(0x03, 0);
		public static const DIV:AesOperation = new AesOperation(0x04, 0);
		public static const RCP:AesOperation = new AesOperation(0x05, AesOperationFlag.NO_SOURCE2); // dest = 1 / src1
		public static const MIN:AesOperation = new AesOperation(0x06, 0);
		public static const MAX:AesOperation = new AesOperation(0x07, 0);
		public static const FRC:AesOperation = new AesOperation(0x08, AesOperationFlag.NO_SOURCE2); // dest = src1 - floor(src1)
		public static const SQT:AesOperation = new AesOperation(0x09, AesOperationFlag.NO_SOURCE2);
		public static const RSQ:AesOperation = new AesOperation(0x0a, AesOperationFlag.NO_SOURCE2); // desc = 1 / (src1 * .5)
		public static const POW:AesOperation = new AesOperation(0x0b, 0);
		public static const LOG:AesOperation = new AesOperation(0x0c, AesOperationFlag.NO_SOURCE2);
		public static const EXP:AesOperation = new AesOperation(0x0d, AesOperationFlag.NO_SOURCE2);
		public static const NRM:AesOperation = new AesOperation(0x0e, AesOperationFlag.NO_SOURCE2);
		public static const SIN:AesOperation = new AesOperation(0x0f, AesOperationFlag.NO_SOURCE2);
		public static const COS:AesOperation = new AesOperation(0x10, AesOperationFlag.NO_SOURCE2);
		public static const CRS:AesOperation = new AesOperation(0x11, 0);
		public static const DP3:AesOperation = new AesOperation(0x12, 0);
		public static const DP4:AesOperation = new AesOperation(0x13, 0);
		public static const ABS:AesOperation = new AesOperation(0x14, AesOperationFlag.NO_SOURCE2);
		public static const NEG:AesOperation = new AesOperation(0x15, AesOperationFlag.NO_SOURCE2);
		public static const SAT:AesOperation = new AesOperation(0x16, AesOperationFlag.NO_SOURCE2);
		public static const M33:AesOperation = new AesOperation(0x17, 0); // векторное произведение двух регистров (cross)
		public static const M44:AesOperation = new AesOperation(0x18, 0); // скалярное произведение двух регистров (dot x,y,z)
		public static const M34:AesOperation = new AesOperation(0x19, 0); // скалярное произведение двух регистров (dot x,y,z,w)
		public static const DDX:AesOperation = new AesOperation(0x1a, AesOperationFlag.NO_SOURCE2);
		public static const DDY:AesOperation = new AesOperation(0x1b, AesOperationFlag.NO_SOURCE2);
		public static const IFE:AesOperation = new AesOperation(0x1c, AesOperationFlag.NO_DESC); // if src1 == src2
		public static const INE:AesOperation = new AesOperation(0x1d, AesOperationFlag.NO_DESC); // if src1 != src2
		public static const IFG:AesOperation = new AesOperation(0x1e, AesOperationFlag.NO_DESC); // if src1 >= src2
		public static const IFL:AesOperation = new AesOperation(0x1f, AesOperationFlag.NO_DESC); // if src1 <  src2
		public static const ELS:AesOperation = new AesOperation(0x20, AesOperationFlag.NO_DESC | AesOperationFlag.NO_SOURCE1 | AesOperationFlag.NO_SOURCE2); // else
		public static const EIF:AesOperation = new AesOperation(0x21, AesOperationFlag.NO_DESC | AesOperationFlag.NO_SOURCE1 | AesOperationFlag.NO_SOURCE2); // end if
		public static const TED:AesOperation = new AesOperation(0x26, 0); // недоступен
		public static const KIL:AesOperation = new AesOperation(0x27, AesOperationFlag.NO_DESC | AesOperationFlag.NO_SOURCE2 | AesOperationFlag.FRAG_ONLY);
		public static const TEX:AesOperation = new AesOperation(0x28, AesOperationFlag.FRAG_ONLY);
		public static const SGE:AesOperation = new AesOperation(0x29, 0); // dest = src1 >= src2 ? 1 : 0
		public static const SLT:AesOperation = new AesOperation(0x2a, 0); // dest = src1 <  src2 ? 1 : 0
		public static const SGN:AesOperation = new AesOperation(0x2b, AesOperationFlag.NO_SOURCE2);
		public static const SEQ:AesOperation = new AesOperation(0x2c, 0); // dest = src1 == src2 ? 1 : 0
		public static const SNE:AesOperation = new AesOperation(0x2d, 0); // dest = src1 != src2 ? 1 : 0
		
	}
}