// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the RICE_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// RICE_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.
#ifdef __cplusplus
extern "C" {
#endif

#ifdef RICE_EXPORTS
#define RICE_API __declspec(dllexport)
#else
#define RICE_API __declspec(dllimport)
#endif


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

RICE_API int Rice_Compress( void *, void *, unsigned int, int );
RICE_API void Rice_Uncompress( void *, void *, unsigned int, unsigned int, int );

#ifdef __cplusplus
}
#endif