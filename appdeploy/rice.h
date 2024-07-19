/*************************************************************************
* Supported binary formats
*************************************************************************/

/* These formats have the same endianity as the machine on which the
   (de)coder is running on */
#define RICE_FMT_INT8   1  /* signed 8-bit integer    */
#define RICE_FMT_UINT8  2  /* unsigned 8-bit integer  */
#define RICE_FMT_INT16  3  /* signed 16-bit integer   */
#define RICE_FMT_UINT16 4  /* unsigned 16-bit integer */
#define RICE_FMT_INT32  7  /* signed 32-bit integer   */
#define RICE_FMT_UINT32 8  /* unsigned 32-bit integer */

/*************************************************************************
* Function prototypes
*************************************************************************/
#define EXPORTED_FUNCTION __declspec(dllexport)

/*************************************************************************
* Rice_Compress() - Compress a block of data using a Rice coder.
*  in     - Input (uncompressed) buffer.
*  out    - Output (compressed) buffer. This buffer must one byte larger
*           than the input buffer.
*  insize - Number of input bytes.
*  format - Binary format
* The function returns the size of the compressed data.
*************************************************************************/
EXPORTED_FUNCTION int Rice_Compress( void *, void *, unsigned int, int );

/*************************************************************************
* Rice_Uncompress() - Uncompress a block of data using a Rice decoder.
*  in      - Input (compressed) buffer.
*  out     - Output (uncompressed) buffer. This buffer must be large
*            enough to hold the uncompressed data.
*  insize  - Number of input bytes.
*  outsize - Number of output bytes.
*  format  - Binary format
*************************************************************************/
EXPORTED_FUNCTION void Rice_Uncompress( void *, void *, unsigned int, unsigned int, int );
